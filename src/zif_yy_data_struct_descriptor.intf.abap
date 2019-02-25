INTERFACE zif_yy_data_struct_descriptor PUBLIC.

  INTERFACES: zif_yy_data_descriptor.

  METHODS: get_structure RETURNING VALUE(r_structure) TYPE zif_yy_data_descriptor=>ty_structure_descriptor.

ENDINTERFACE.
