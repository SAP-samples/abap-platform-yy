CLASS zcl_yy_data_struct_descriptor DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_struct_descriptor.
    CLASS-METHODS: create_instance IMPORTING i_name                        TYPE string
                                             i_type                        TYPE REF TO zif_yy_data_element_type
                                             i_structure_descriptor        TYPE zif_yy_data_descriptor=>ty_structure_descriptor
                                   RETURNING VALUE(r_structure_descriptor) TYPE REF TO zcl_yy_data_struct_descriptor.

  PROTECTED SECTION.

  PRIVATE SECTION.
    DATA: my_structure TYPE zif_yy_data_descriptor=>ty_structure_descriptor,
          my_name TYPE string,
          my_type TYPE REF TO zif_yy_data_element_type.
    METHODS: constructor IMPORTING i_name                 TYPE string
                                   i_type                 TYPE REF TO zif_yy_data_element_type
                                   i_structure_descriptor TYPE zif_yy_data_descriptor=>ty_structure_descriptor.
ENDCLASS.



CLASS ZCL_YY_DATA_STRUCT_DESCRIPTOR IMPLEMENTATION.


  METHOD constructor.
    my_name = i_name.
    my_type = i_type.
    my_structure = i_structure_descriptor.
  ENDMETHOD.


  METHOD create_instance.
    r_structure_descriptor = NEW zcl_yy_data_struct_descriptor( i_name = i_name
                                                                i_type = i_type
                                                                i_structure_descriptor = i_structure_descriptor ).
  ENDMETHOD.


  METHOD zif_yy_data_descriptor~get_name.
    r_name = my_name.
  ENDMETHOD.


  METHOD zif_yy_data_descriptor~get_type.
    r_type = my_type.
  ENDMETHOD.


  METHOD zif_yy_data_struct_descriptor~get_structure.
    r_structure = my_structure.
  ENDMETHOD.
ENDCLASS.
