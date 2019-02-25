CLASS zcl_yy_data_descriptor DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_descriptor.
    CLASS-METHODS: create_instance IMPORTING i_name                   TYPE string
                                             i_type                   TYPE REF TO zif_yy_data_element_type
                                   RETURNING VALUE(r_data_descriptor) TYPE REF TO zcl_yy_data_descriptor.
  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS: constructor IMPORTING i_name TYPE string
                                   i_type TYPE REF TO zif_yy_data_element_type.
    DATA: my_name TYPE string,
          my_type TYPE REF TO zif_yy_data_element_type.
ENDCLASS.



CLASS ZCL_YY_DATA_DESCRIPTOR IMPLEMENTATION.


  METHOD constructor.
    my_name = i_name.
    my_type = i_type.
  ENDMETHOD.


  METHOD create_instance.
    r_data_descriptor = NEW zcl_yy_data_descriptor( i_name = i_name
                                                    i_type = i_type ).
  ENDMETHOD.


  METHOD zif_yy_data_descriptor~get_name.
    r_name = my_name.
  ENDMETHOD.


  METHOD zif_yy_data_descriptor~get_type.
    r_type = my_type.
  ENDMETHOD.
ENDCLASS.
