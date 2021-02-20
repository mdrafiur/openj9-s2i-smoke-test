import os
import re
import argparse
from urllib.request import urlopen


def get_url_content(build_url):
    page = urlopen(build_url)
    html_bytes = page.read()
    html = html_bytes.decode("utf-8")
    f = open("buildURLContent.txt", "w")
    f.write(html)
    f.close()


def get_build_version():
    with open('buildURLContent.txt') as fd:

        # Iterate over the lines
        for line in fd:

            # Capture one-or-more characters of non-whitespace after the initial match
            match = re.search(r'.*buildID=[0-9]{7}\"\>(\S+)', line)

            # Did we find a match?
            if match:
                # Yes, process it
                bid = match.group(1)
                buildID = bid.split('<')[0]
                print(buildID[-6:], file=open('result.txt', 'w'))


def main():
    parser = argparse.ArgumentParser(description='Arguments get parsed via --commands')
    parser.add_argument("-url", "--build_url", required=True, help="brew task url")
    args = vars(parser.parse_args())
    arg_list=list(args.values())

    get_url_content(arg_list[0])
    get_build_version()


if __name__ == '__main__':
    main()