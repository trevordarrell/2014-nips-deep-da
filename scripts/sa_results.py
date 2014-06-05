from generate_full_office_table import load_results, Datapoint
import argparse
from itertools import product
import numpy as np
from tabulate import tabulate

Datapoint.METHODS = ['sa']

def emit_results(results):
    domains = ('amazon', 'dslr', 'webcam')
    indices = []
    headers = ['']
    for src, tgt in product(domains, repeat=2):
        if src == tgt: continue
        indices.append('{}->{}'.format(src, tgt))
        headers.append(r'${} \rightarrow {}$'.format(src[0].upper(),
                                                     tgt[0].upper()))
    rows = []
    PT_FMT = r'${:2.2f} \pm {:1.1f}$'
    row = []
    row.append('SA')
    for index in indices:
        data = results[index]['sa']
        row.append(PT_FMT.format(np.mean(data),
                                 np.std(data) / np.sqrt(len(data))))
    rows.append(row)
    print tabulate(rows, headers, tablefmt='latex')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('resultspath',
                        nargs='?', default='data/full_office_expt')
    args = parser.parse_args()

    results = load_results(args.resultspath)

    emit_results(results)
