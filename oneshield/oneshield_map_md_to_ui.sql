select 
pkg_os_bv.fn_bv_name_get(substr(      
(nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path ))  , 
instr( (nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path )),'.',-1)+1 , length(cell_Business_variable_path))) 
as business_variable_name, 
substr(      
(nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path ))  , 
instr( (nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path )),'.',-1)+1 , length(cell_Business_variable_path))
as business_variable_id,
pkg_os_object_type.fn_object_type_name_get(pkg_os_bv.fn_bv_path_object_type_get(substr(      
(nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path ))  , 
instr( (nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path )),'.',-1)+1 , length(cell_Business_variable_path)))) -- get container type, then name of it via fn_bv_path_object_type_get, fn_object_type_name_get
as variable_container,
pkg_cs_xformer_extension.fn_get_Logical_datatype(substr(      
(nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path ))  , 
instr( (nvl(substr(cell_Business_variable_path,1,instr(cell_Business_variable_path,'')-1),cell_Business_variable_path )),'.',-1)+1 , length(cell_Business_variable_path))) -- get name of data type
as data_type_name,
plc.cell_logical_data_type_id as data_type_it_id, plc.cell_label, plb2.block_name as IT_block_name, plb2.block_title 
from page_layout_cell plc inner join page_layout_block plb2 ON plc.PAGE_LAYOUT_BLOCK_ID = plb2.PAGE_LAYOUT_BLOCK_ID where plc.cell_business_variable_path is not null and plb2.page_layout_block_id in (
  select plb1.page_layout_block_id from page_layout_block plb1 where plb1.page_layout_id = ( -- get all blocks
    select page_layout_id from action ac where ac.action_id = 612546)) order by plb2.block_row_number asc, plb2.page_layout_block_id asc,  plc.cell_row_number asc, plc.cell_col_number asc; -- starting action