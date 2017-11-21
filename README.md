# SOS experiments with mapserver

## Data

`db.sql` provided by Rennes Métropole, creates a `mobilite_transp` db schema, and 5 tables filled with test data.
Data comes from a road traffic sensor, aggregated on a hourly basis.


## Service

Run the services with `docker-compose up`

Example queries:
 * GetCapabilities
   * http://localhost:8080/mapserv?MAP=/etc/mapserver/mapserver.map&SERVICE=SOS&REQUEST=GetCapabilities 
 * GetObservation 
   * http://localhost:8080/mapserv?MAP=/etc/mapserver/mapserver.map&SERVICE=SOS&Request=GetObservation&offering=rennes&observedproperty=vehicles&version=1.0.0&responseFormat=text/xml;%20subtype=%22om/1.0.0%22
   * http://localhost:8080/mapserv?MAP=/etc/mapserver/mapserver.map&SERVICE=SOS&Request=GetObservation&offering=rennes&observedproperty=vehicles&version=1.0.0&responseFormat=text/xml;%20subtype=%22om/1.0.0%22&resultModel=om:Observation
 * ...


## Client

Open http://localhost:8080/ol2/examples/sos.html

We expect to display here the `featureOfInterest`s the server offers.

MapServer has a strange implementation for `featureOfInterest`.
It says about featureOfInterest: `(Optional) In this implementation, this will be represented by a gml envelope defining the lower and upper corners.`, when we would have expected true features.

Our server currently offers a single layer with a unique `featureOfInterest` whose urn is `urn:ogc:def:feature:OGC-SWE:3:transient`, matching sensor with `station_id = 1`.


The SOS getCapabilities request succeeds, but the next request, which is a POST to http://localhost:8080/mapserv?MAP=/etc/mapserver/mapserver.map& with the following content, fails.
```xml
<GetFeatureOfInterest xmlns="http://www.opengis.net/sos/1.0" version="1.0.0" service="SOS" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/sos/1.0 http://schemas.opengis.net/sos/1.0.0/sosAll.xsd"><FeatureOfInterestId>urn:ogc:def:feature:OGC-SWE:3:transient</FeatureOfInterestId></GetFeatureOfInterest>
```

Indeed, MapServer does not seem to support POST SOS requests, while OpenLayers is currently designed to use POST requests for `sos:GetFeatureOfInterest`, see https://github.com/openlayers/ol2/blob/e85a087c8fb857648aa7c5e4f771d1d2a13fc48b/lib/OpenLayers/Protocol/SOS/v1_0_0.js#L76-L83.
