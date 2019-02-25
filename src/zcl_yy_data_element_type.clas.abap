CLASS zcl_yy_data_element_type DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    INTERFACES: zif_yy_data_element_type.
    CLASS-METHODS: create_instance IMPORTING i_type_name           TYPE zif_yy_data_element_type=>ty_type
                                   RETURNING VALUE(r_element_type) TYPE REF TO zif_yy_data_element_type.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA: my_type_name TYPE zif_yy_data_element_type=>ty_type.
    METHODS: constructor IMPORTING i_type_name TYPE zif_yy_data_element_type=>ty_type.
ENDCLASS.



CLASS ZCL_YY_DATA_ELEMENT_TYPE IMPLEMENTATION.


  METHOD constructor.
    my_type_name = i_type_name.
  ENDMETHOD.


  METHOD create_instance.
    r_element_type = NEW zcl_yy_data_element_type( i_type_name = i_type_name ).
  ENDMETHOD.


  METHOD zif_yy_data_element_type~get_type_name.
    r_type_name = my_type_name.
  ENDMETHOD.
ENDCLASS.
