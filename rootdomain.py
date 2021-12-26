# coding=utf8
# the above tag defines encoding for this document and is for Python 2.x compatibility

import re

regex = r"[^.]*.[^.]{2,3}(?:.[^.]{2,3})?$"

with open('all.txtls', 'r') as test_str:
	data = test_str.read()

matches = re.finditer(regex, data, re.MULTILINE)

for matchNum, match in enumerate(matches, start=1):
    
    print ("Match {matchNum} was found at {start}-{end}: {match}".format(matchNum = matchNum, start = match.start(), end = match.end(), match = match.group()))
    
    for groupNum in range(0, len(match.groups())):
        groupNum = groupNum + 1
        
        print ("Group {groupNum} found at {start}-{end}: {group}".format(groupNum = groupNum, start = match.start(groupNum), end = match.end(groupNum), group = match.group(groupNum)))

# Note: for Python 2.7 compatibility, use ur"" to prefix the regex and u"" to prefix the test string and substitution.
# code taken from - https://regex101.com/r/fX1fI5/2/codegen?language=python
