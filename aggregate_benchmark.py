import json
import math
import sys

def main():
    fname = sys.argv[1]

    allResults = {
        '10': [],
        '20': [],
        '50': [],
        '100': [],
        '250': [],
        '500': []
    }

    with open(fname) as f:
        for line in f:
            if "cummulativeResult" in line:
                result = json.loads(line)
                allResults[str(result['cummulativeResult']['concurrency'])].append(result['cummulativeResult'])

    aggregatedResults = {
        '10': {},
        '20': {},
        '50': {},
        '100': {},
        '250': {},
        '500': {}
    }
    for key in allResults.keys():
        aggregatedResults[key]['AvgRequestTime'] = 0
        aggregatedResults[key]['MinRequestTime'] = 999999999
        aggregatedResults[key]['MaxRequestTime'] = 0
        aggregatedResults[key]['StandardDeviation'] = 0
        aggregatedResults[key]['AvgThroughput'] = 0

        for item in allResults[key]:
            # Sum Up Average Reqeust Times before dividing by number of occurances
            aggregatedResults[key]['AvgRequestTime'] += item['averageRequestTime (ms)']
            # Find Absolute Min
            if item['minimumRequestTime (ms)'] < aggregatedResults[key]['MinRequestTime']:
                aggregatedResults[key]['MinRequestTime'] = item['minimumRequestTime (ms)']
            # Find Absolute Max
            if item['maximumRequestTime (ms)'] > aggregatedResults[key]['MaxRequestTime']:
                aggregatedResults[key]['MaxRequestTime'] = item['maximumRequestTime (ms)']
            # Get Variance(=StanDev^2) and Sum up before dividing by number of occurances
            aggregatedResults[key]['StandardDeviation'] += item['standardDeviation (ms)']**2
            # Sum Up Average Throughputs before dividing by nmber of occurances
            aggregatedResults[key]['AvgThroughput'] += item['contentThroughput (MB/s)']

        # Divide by Number of Occurances
        aggregatedResults[key]['AvgRequestTime'] /= len(allResults[key])
        aggregatedResults[key]['StandardDeviation'] /= len(allResults[key])
        aggregatedResults[key]['AvgThroughput'] /= len(allResults[key])

        # Take Sqrt of Avg(Variance) for AvgStandardDeviation
        aggregatedResults[key]['StandardDeviation'] = math.sqrt(aggregatedResults[key]['StandardDeviation'])

        print('Concurrency: ' + str(key))
        print('Avg Request Time (ms): ' + str(aggregatedResults[key]['AvgRequestTime']))
        print('Min Request Time (ms): ' + str(aggregatedResults[key]['MinRequestTime']))
        print('Max Request Time (ms): ' + str(aggregatedResults[key]['MaxRequestTime']))
        print('Standard Deviation: ' + str(aggregatedResults[key]['StandardDeviation']))
        print('Avg Throughput (MB/s): ' + str(aggregatedResults[key]['AvgThroughput']) + '\n')


if __name__ == '__main__':
    main()
