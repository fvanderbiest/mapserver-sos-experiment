# SOS experiments with mapserver

## Data

`db.sql` provided by Rennes Métropole, creates a `mobilite_transp` db schema, and 5 tables filled with test data.
Data comes from a road traffic sensor, aggregated on a hourly basis.


## Service

Run the mapserver service with `docker-compose up` and open http://localhost:8080/?MAP=/etc/mapserver/mapserver.map&SERVICE=SOS&REQUEST=GetCapabilities

Example queries:
 * GetObservation http://localhost:8080/?MAP=/etc/mapserver/mapserver.map&SERVICE=SOS&Request=GetObservation&Offering=rennes&observedproperty=nb_total&version=1.0.0&responseFormat=text/xml;%20subtype=%22om/1.0.0%22
 * ...
