# YY Data Service

<hr />

**Attention: This is sample code!** 

This repository contains sample code which should not be used in production. It only shows the capabilities of [APACK - the ABAP package and dependency manager](https://blogs.sap.com/2019/05/06/introducing-apack-a-package-and-dependency-manager-for-abap/).

<hr />

**A Poor Man's RTTI for the ABAP Environment on SAP Cloud Platform**

This small library - called the YY Data Service - is an alternative approach towards RTTI on an ABAP system running on the SAP Cloud Platform. Keep in mind that this is just a demo. In production, you better use the officially supported RTTI...

## Prerequisites
Please make sure to fulfill the following requirements:
* You have access to an SAP Cloud Platform ABAP Environment instance (see [here](https://blogs.sap.com/2018/09/04/sap-cloud-platform-abap-environment) for additional information)
* You have downloaded and installed [ABAP Development Tools for SAP NetWeaver](https://tools.hana.ondemand.com/#abap) (ADT)
* You have created an ABAP Cloud Project in ADT that allows you to access your SAP Cloud Platform ABAP Environment instance
* You have installed the [abapGit](https://github.com/abapGit/eclipse.abapgit.org) plug-in for Eclipse [via the updatesite](https://eclipse.abapgit.org/updatesite/)

## Download and Installation
Use the abapGit plug-in to install the YY Data Service by executing the following steps:
* In ADT create the package `/DMO/YY` as a subpackage under `/DMO/SAP` (keep the defaulted values)
* In ADT click on `Window` > `Show View` > `Other...` and choose the entry `abapGit Repositories` to open the abapGit view
* Make sure to have the correct ABAP Cloud Project selected (See the little headline in the abapGit view for the current project)
* Click on the `+` icon to clone an abapGit repository
* Provide the URL of this repository: `https://github.com/SAP/abap-platform-yy.git`
* On the next page choose the master branch and provide the package `/DMO/YY`
* Provide a valid transport request and choose `Finish`. This starts the cloning of the repository - which might take a few minutes
* Once the cloning has finished, refresh your project tree
* Usually, the imported objects are not activated after cloning. Use the mass activation feature in ADT to activate those artifacts.

## Usage
If you want to get some information about ABAP data in the Cloud, YY makes it really easy for you. The service is ready-to-use, no configuration is necessary. Simply get an instance of the service class by calling `ZCL_YY_ABAP_DATA_SERVICE=>CREATE_INSTANCE`. The one and only parameter `I_DATA` expects the data which you want to investigate.

The resulting object of type `ZIF_YY_DATA_ELEMENT` has two methods, `GET_DESCRIPTOR` and `GET_VALUE`.

### ZIF_YY_DATA_ELEMENT=>GET_DESCRIPTOR
This method returns an object of type `ZIF_YY_DATA_DESCRIPTOR` which describes the metadata of the respective element. If the element has a name (e.g. as a structure element), you'll find this name by calling the method `GET_NAME`. If there was no name, it will return the value of `ZIF_YY_DATA_DESCRIPTOR=>CO_UNNAMED_OBJECT`. The more important information is probably the type of the data element which you can get by calling `GET_TYPE`. This one returns an instance of the interface `ZIF_YY_DATA_ELEMENT_TYPE`. It's currently one and only method `GET_TYPE_NAME` returns a textual representation of the data type. Constants for currently supported ones can be found in the interface `ZIF_YY_DATA_ELEMENT_TYPE` as well. Depending on this format you need to decide which format your variable needs to have which you use to get the actual data from `GET_VALUE`...

### ZIF_YY_DATA_ELEMENT=>GET_VALUE
If you have a simple data type such as a number or text, you get it directly back using this method. For structures and tables it's slightly more difficult. There you get the full information about the structure or the table in a nice format, either `ZIF_YY_DATA_ELEMENT=>TY_STRUCTURE` or `ZIF_YY_DATA_ELEMENT=>TY_TABLE`. They feature the structure elements  or the table lines with their corresponding data element objects in their original order of sequence.

## Limitations
Currently no support for objects (reference types), only simple data types, structures and tables. And it's not even guaranteed that it works for them as you might expect... It's sample code!

## Known Issues
As mentioned before, after cloning a abapGit repository some objects might not be active. Use the mass activation feature in ADT to activate those artifacts.  

## License
Copyright (c) 2019 SAP SE or an SAP affiliate company. All rights reserved.
This project is licensed under the SAP Sample Code License except as noted otherwise in the [LICENSE](LICENSE) file.
