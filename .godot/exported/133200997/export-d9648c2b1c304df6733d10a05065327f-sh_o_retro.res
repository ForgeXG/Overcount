RSRC                    VisualShader            ��������                                            1      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    size    expression 	   constant    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/3/size    nodes/fragment/3/input_ports    nodes/fragment/3/output_ports    nodes/fragment/3/expression    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_fk2qw +      )   local://VisualShaderNodeExpression_l6rt4 c      ,   local://VisualShaderNodeFloatConstant_va6lt �      '   res://shaders/overlays/sh_o_retro.tres �         VisualShaderNodeInput             color          VisualShaderNodeExpression       
     4D  �C	      �   float metric = col.x + col.y + col.z;
if (metric == 0.0) {
	res = vec3(0.0, 1.0, 0.0) * 0.9;
} else {
	res = vec3(0.0, 0.0, 0.0);
}
if (col.a + metric > 1.0) {
	res = vec3(0.0, 1.0, 0.0) * 0.1;
}
alpha = col.a >= 0.6 ? 1.0 : 0.0;          VisualShaderNodeFloatConstant    
        �?         VisualShader          8  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// Input:2
	vec4 n_out2p0 = COLOR;


	vec3 n_out3p0;
	float n_out3p1;
// Expression:3
	n_out3p0 = vec3(0.0, 0.0, 0.0);
	n_out3p1 = 0.0;
	{
		float metric = n_out2p0.x + n_out2p0.y + n_out2p0.z;
		if (metric == 0.0) {
			n_out3p0 = vec3(0.0, 1.0, 0.0) * 0.9;
		} else {
			n_out3p0 = vec3(0.0, 0.0, 0.0);
		}
		if (n_out2p0.a + metric > 1.0) {
			n_out3p0 = vec3(0.0, 1.0, 0.0) * 0.1;
		}
		n_out3p1 = n_out2p0.a >= 0.6 ? 1.0 : 0.0;
	}


// Output:0
	COLOR.rgb = n_out3p0;
	COLOR.a = n_out3p1;


}
                       
     D   C                
     M�  HC               
     ��  4C   
     4D  �C      	   0,5,col;          0,4,res;1,0,alpha;       �   float metric = col.x + col.y + col.z;
if (metric == 0.0) {
	res = vec3(0.0, 1.0, 0.0) * 0.9;
} else {
	res = vec3(0.0, 0.0, 0.0);
}
if (col.a + metric > 1.0) {
	res = vec3(0.0, 1.0, 0.0) * 0.1;
}
alpha = col.a >= 0.6 ? 1.0 : 0.0;                
     �C  �C                                                           RSRC