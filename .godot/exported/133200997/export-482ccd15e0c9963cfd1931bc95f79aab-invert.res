RSRC                    VisualShader            ��������                                            8      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    op_type 	   operator 	   constant 	   function    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections     	   $   local://VisualShaderNodeInput_2l6hw �      '   local://VisualShaderNodeVectorOp_axf7m       ,   local://VisualShaderNodeFloatConstant_3bpqi �      '   local://VisualShaderNodeVectorOp_4ithm �      ,   local://VisualShaderNodeFloatConstant_uxfga F	      )   local://VisualShaderNodeVectorFunc_cy10r t	      '   local://VisualShaderNodeVectorOp_2jbdi �	      ,   local://VisualShaderNodeFloatConstant_ccte3 d
          res://shaders/shade/invert.tres �
         VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                         	                  VisualShaderNodeFloatConstant    
        �?         VisualShaderNodeVectorOp                                                                                  VisualShaderNodeFloatConstant             VisualShaderNodeVectorFunc                                                                  VisualShaderNodeVectorOp                                                                         	                  VisualShaderNodeFloatConstant    
        �?         VisualShader          1  shader_type canvas_item;
render_mode blend_mix;




void fragment() {
// FloatConstant:4
	float n_out4p0 = 1.000000;


// Input:2
	vec4 n_out2p0 = COLOR;


// VectorOp:3
	vec4 n_out3p0 = vec4(n_out4p0) - n_out2p0;


// VectorFunc:7
	vec4 n_out7p0 = max(min(n_out3p0, vec4(1.0)), vec4(0.0));


// FloatConstant:9
	float n_out9p0 = 1.000000;


// VectorOp:8
	vec4 n_out8p0 = n_out7p0 * vec4(n_out9p0);


// FloatConstant:6
	float n_out6p0 = 0.000000;


// VectorOp:5
	vec4 n_out5p0 = n_out8p0 + vec4(n_out6p0);


// Output:0
	COLOR.rgb = vec3(n_out5p0.xyz);


}
                                    
     �  �C               
     ��  4C               
     ��  HC               
     \C   C                
     H�  �C!            "   
     �  HC#            $   
     �A  HC%            &   
     H�  �C'                                                                                               	                                RSRC