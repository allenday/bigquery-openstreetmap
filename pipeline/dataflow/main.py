"""
Beam pipeline that reads OSM GeoJSON file, transforms it and uploads to BigQuery
"""

import re
import csv
import sys
import logging
import datetime

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.metrics import Metrics

from apache_beam.io.gcp import bigquery
from apache_beam.io.gcp.bigquery_file_loads import BigQueryBatchFileLoads

CSV_HEADERS = ['geometry', 'osm_id', 'osm_way_id', 'osm_version', 'osm_timestamp', 'all_tags']

BQ_SCHEMA = {
    "fields": [
        {
            "type": "INTEGER",
            "name": "osm_id"
        },

        {
            "type": "INTEGER",
            "name": "osm_way_id"
        },
        {
            "type": "INTEGER",
            "name": "osm_version"
        },

        {
            "type": "TIMESTAMP",
            "name": "osm_timestamp"
        },
        {
            "fields": [
                {
                    "type": "STRING",
                    "name": "key"
                },
                {
                    "type": "STRING",
                    "name": "value"
                }
            ],
            "type": "RECORD",
            "name": "all_tags",
            "mode": "REPEATED"
        },
        {
            "type": "GEOGRAPHY",
            "name": "geometry"
        }
    ]
}


class CSVtoDict(beam.DoFn):
    """Converts line from input file into dictionary"""

    def __init__(self):
        self.bad_lines = Metrics.counter(self.__class__, 'bad_lines')

    def process(self, element, headers):
        import sys
        csv.field_size_limit(sys.maxsize)
        rec = ""
        try:
            for line in csv.reader([element]):
                rec = line

            if len(rec) == len(headers):
                data = {header.strip(): val.strip() for header, val in zip(headers, rec)}
                return [data]
            else:
                self.bad_lines.inc()
                logging.error("bad: {rec}".format(rec=rec))
        except Exception as e:
            logging.error(e)
            self.bad_lines.inc()


class Convert(beam.DoFn):
    """Converts OSM geojson data suitable for BigQuery upload """

    def __init__(self):
        self.bad_lines = Metrics.counter(self.__class__, 'bad_lines')

    def process(self, line, *args, **kwargs):

        geom = line['geometry']
        tags_str = line['all_tags']

        tags_lst = re.findall('"(.*?)"=>"(.*?)"', tags_str)
        dt_str = line['osm_timestamp']
        try:
            dt = datetime.datetime.strptime(dt_str, '%Y/%m/%d %H:%M:%S').strftime('%s')
            tags_out = []
            for k, v in tags_lst:
                tags_dict = dict()
                tags_dict['key'] = k
                tags_dict['value'] = v
                tags_out.append(tags_dict)
            osm_id = line.get('osm_id')
            if osm_id:
                osm_id = int(osm_id)
            else:
                osm_id = None

            osm_way_id = line.get('osm_way_id')
            if osm_way_id:
                osm_way_id = int(osm_way_id)
            else:
                osm_way_id = None

            out = {
                'geometry': geom,
                'all_tags': tags_out,
                'osm_id': osm_id,
                'osm_way_id': osm_way_id,
                'osm_version': int(line['osm_version']),
                'osm_timestamp': int(dt),
            }
            return [out]
        except Exception as e:
            self.bad_lines.inc()
            logging.error(e)
            logging.error(line)


class TemplatedOptions(PipelineOptions):
    """input file for processing"""

    @classmethod
    def _add_argparse_args(cls, parser):
        parser.add_value_provider_argument(
            '--input',
            required=False,
            help='fulls GCS path (with gs://) for input file')
        parser.add_value_provider_argument(
            '--bq_destination',
            required=False,
            help='full BigQuery destination path in format: projectId:dataset_name.table_name')


def run(run_local):
    pipeline_options = {
        'disk_size_gb': 100,
        'save_main_session': True,
        'network': 'dataflow',
        'no_use_public_ips': True,
        'max_num_workers': 150
    }

    options = PipelineOptions(flags=sys.argv, **pipeline_options)
    custom_options = options.view_as(TemplatedOptions)

    additional_bq_parameters = {
        'maxBadRecords': 100,
    }

    p = beam.Pipeline(options=options)

    parse = (p | 'Reading input file' >> beam.io.ReadFromText(custom_options.input, skip_header_lines=1)
             | 'Converting from csv to dict' >> beam.ParDo(CSVtoDict(), CSV_HEADERS)
             | 'Format data' >> beam.ParDo(Convert())
             )

    (
            parse | 'Load to BQ' >> BigQueryBatchFileLoads(
                custom_options.bq_destination,
                create_disposition=bigquery.BigQueryDisposition.CREATE_IF_NEEDED,
                write_disposition=bigquery.BigQueryDisposition.WRITE_TRUNCATE,
                schema=BQ_SCHEMA,
                additional_bq_parameters=additional_bq_parameters
            )
    )

    result = p.run()
    if run_local:
        result.wait_until_finish()


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.DEBUG)
    run_local = False
    run(run_local)
