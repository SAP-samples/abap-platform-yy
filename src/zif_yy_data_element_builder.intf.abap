INTERFACE zif_yy_data_element_builder PUBLIC.

  METHODS: build IMPORTING i_data_reader  TYPE REF TO if_sxml_reader
                           i_element_name TYPE string
                 RAISING   zcx_yy_unsupported_data.

ENDINTERFACE.
