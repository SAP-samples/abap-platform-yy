CLASS zcl_yy_apack_manifest DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_apack_manifest.
    METHODS: constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_yy_apack_manifest IMPLEMENTATION.
  METHOD constructor.
    if_apack_manifest~descriptor-group_id = 'sap.com'.
    if_apack_manifest~descriptor-artifact_id = 'abap-platform-yy'.
    if_apack_manifest~descriptor-version = '0.1'.
    if_apack_manifest~descriptor-git_url = 'https://github.com/SAP/abap-platform-yy.git'.
  ENDMETHOD.

ENDCLASS.
