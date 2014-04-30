import json
from subprocess import call

def getCats(categories):

  for jsonDict in categories:
    ident = jsonDict['id']
    prefix = jsonDict['icon']['prefix']
    suffix = jsonDict['icon']['suffix']
    url = prefix + 'bg_' + '32' + suffix

    call(['wget', url, '-O', ident + suffix])

    if 'categories' in jsonDict:
      getCats(jsonDict['categories'])


jsonFile = open('categories.json', 'r')
jsonDict = json.loads(jsonFile.read())
jsonFile.close()
getCats(jsonDict['response']['categories'])

