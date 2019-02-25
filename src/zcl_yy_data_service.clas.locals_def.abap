*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
class lcl_element_type_unsupported definition.
  public section.
    interfaces: zif_yy_data_element_type.
endclass.
CLASS lcl_data_element_unsupported DEFINITION.
  PUBLIC SECTION.
    INTERFACES: zif_yy_data_element.
    METHODS: constructor.
    DATA: my_descriptor TYPE REF TO zif_yy_data_descriptor.
ENDCLASS.
