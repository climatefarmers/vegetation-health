#!/usr/bin/env python
# coding: utf-8

# In[ ]:


##aprrove terms and conditions of use at least once with your token @wekeo.eu sign-in
##@: https://www.wekeo.eu/docs/harmonised-data-access-api
## curl --request PUT --header 'accept: application/json' --header 'authorization: <access_token>' --data 'accepted=true' https://wekeo-broker.apps.mercator.dpi.wekeo.eu/databroker/termsaccepted/Copernicus_General_License


# In[12]:


from hda import Client
import os


# In[13]:


def get_parent_dir(directory):
    return os.path.dirname(directory)

current_dirs_parent = get_parent_dir(os.getcwd())


# In[14]:


##ad out directory where to download the files
outdir = '/home/neuwirth/work/GIS/Projekte/Fernerkundung/0_Daten/Europe/Sentinel2/'

#add wekeo accountinfo to textfile
lines = ['url: https://wekeo-broker.apps.mercator.dpi.wekeo.eu/databroker',
         'user: XXX',
         'password: XXX']

with open(current_dirs_parent+'/.hdarc', 'w') as f:
    f.write('\n'.join(lines))


# In[15]:


c = Client(url="https://wekeo-broker.apps.mercator.dpi.wekeo.eu/databroker",debug=True)


# In[16]:


os.chdir(outdir)


# In[20]:


query = {
  "datasetId": "EO:ESA:DAT:SENTINEL-2:MSI",
  "boundingBoxValues": [
    {
      "name": "bbox",
      "bbox": [
        -8.612802734375,
        38.138437871376254,
        -8.118850107255466,
        38.62992694505725
      ]
    }
  ],
  "dateRangeSelectValues": [
    {
      "name": "position",
      "start": "2020-08-01T00:00:00.000Z",
      "end": "2021-02-01T00:00:00.000Z"
    }
  ],
  "stringChoiceValues": [
    {
      "name": "processingLevel",
      "value": "LEVEL2A"
    }
  ]
}
matches = c.search(query)


# In[21]:


os.getcwd()


# In[ ]:


#print(matches)
matches.download()

