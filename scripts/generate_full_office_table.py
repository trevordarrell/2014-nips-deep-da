from tabulate import tabulate

import numpy as np
from scipy.io import loadmat

import argparse
from collections import defaultdict
from glob import glob
from itertools import product
import os.path

class Datapoint(object):
    """Data class for accessing results loaded from a .mat file."""

    METHODS = ['svm_s', 'svm_t', 'daume']

    def __init__(self, info_dict):
        self.ft = info_dict['ft']
        self.source = info_dict['source']
        self.target = info_dict['target']
        self.accuracies = {}
        for method in self.METHODS:
            self.accuracies[method] = float(info_dict['accuracies'][method])

    def __repr__(self):
        return '<Result {}->{}>'.format(self.source, self.target)

    @classmethod
    def from_file(cls, matfile):
        return cls(loadmat(matfile, squeeze_me=True))

def load_results(resultspath):
    data = []
    for matfile in glob(os.path.join(resultspath, '*.mat')):
        data.append(Datapoint.from_file(matfile))
    results = defaultdict(lambda: defaultdict(lambda: []))
    for pt in data:
        shift_str = '{}->{}'.format(pt.source, pt.target)
        for method in Datapoint.METHODS:
            results[shift_str][method].append(pt.accuracies[method])
    return results

def emit_table(results):
    domains = ('amazon', 'dslr', 'webcam')
    names = {'svm_s': 'SVM (Source Only)',
             'svm_t': 'SVM (Target Only)',
             'daume': r'\daume~\cite{daume}'}
    indices = []
    headers = ['']
    for src, tgt in product(domains, repeat=2):
        if src == tgt: continue
        indices.append('{}->{}'.format(src, tgt))
        headers.append(r'${} \rightarrow {}$'.format(src[0].upper(),
                                                     tgt[0].upper()))
    rows = []
    PT_FMT = r'${:2.2f} \pm {:1.1f}$'
    for method in Datapoint.METHODS:
        row = []
        row.append(names[method])
        for index in indices:
            data = results[index][method]
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
    emit_table(results)
