# Tags and Dockerfiles
- `latest`, ([Dockerfile]())

# PDS Transform

This software transforms PDS3 and PDS4 product labels and product data into common formats.

https://pds.nasa.gov/pds4/software/transform/

## Example

### Converting PDS3 LBL file to PDS4:

```
docker run -it --rm -v ${PWD}:/host danisla/pds-transform:v1.3.0 /host/examples/ELE_MOM.LBL -f pds4-label -a -o /host/examples
```

You should now have a file: `examples/ele_mom.xml`

### Converting PDS4 xml file to csv:

```
docker run -it --rm -v ${PWD}:/host danisla/pds-transform:v1.3.0 /host/examples/ele_mom.xml -f csv -a -o /host/examples
```

### Convert PDS3 LBL to csv with Make

```
make examples/ELE_MOM.csv
```
