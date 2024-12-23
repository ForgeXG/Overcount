RSRC                    VisualShader            ��������                                            O      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    size    expression    script    op_type 	   operator    input_name 	   function    parameter_name 
   qualifier    hint    min    max    step    default_value_enabled    default_value    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/4/size    nodes/fragment/4/input_ports    nodes/fragment/4/output_ports    nodes/fragment/4/expression    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/11/node    nodes/fragment/11/position    nodes/fragment/12/node    nodes/fragment/12/position    nodes/fragment/13/node    nodes/fragment/13/position    nodes/fragment/14/node    nodes/fragment/14/position    nodes/fragment/16/node    nodes/fragment/16/position    nodes/fragment/17/node    nodes/fragment/17/position    nodes/fragment/18/node    nodes/fragment/18/position    nodes/fragment/19/node    nodes/fragment/19/position    nodes/fragment/20/node    nodes/fragment/20/position    nodes/fragment/21/node    nodes/fragment/21/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        )   local://VisualShaderNodeExpression_tulag �
      '   local://VisualShaderNodeVectorOp_s7ndr �      $   local://VisualShaderNodeInput_h5wme j      $   local://VisualShaderNodeInput_vvcmo �      $   local://VisualShaderNodeInput_s02ig �      $   local://VisualShaderNodeInput_cafjt       (   local://VisualShaderNodeColorFunc_tptxm Y      '   local://VisualShaderNodeVectorOp_nls70 �      $   local://VisualShaderNodeInput_newj4       '   local://VisualShaderNodeVectorOp_b3hoj 9      '   local://VisualShaderNodeVectorOp_vp1wb �      '   local://VisualShaderNodeVectorOp_8nfnc       -   local://VisualShaderNodeFloatParameter_bryp6 �      *   res://shaders/overlays/sh_o_physical.tres �         VisualShaderNodeExpression       
     D  D      �   v *= 5.0;
float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
res.x = 1.0;
res.y = 0.0;
res.z = sin(r - t) >= 0.0 ? 1.0 : (tint);          VisualShaderNodeVectorOp                                                                	         
                  VisualShaderNodeInput             color          VisualShaderNodeInput          
   screen_uv          VisualShaderNodeInput             time          VisualShaderNodeInput             screen_pixel_size          VisualShaderNodeColorFunc                      VisualShaderNodeVectorOp                    
                 
     �?  �?	          
                  VisualShaderNodeInput             uv          VisualShaderNodeVectorOp                    
                 
      �   �	                   VisualShaderNodeVectorOp                    
                 
     �?  �?	          
                  VisualShaderNodeVectorOp                    
     �B  �B      
     �B  �B	          
                  VisualShaderNodeFloatParameter             tint                   @                  @         VisualShader $           shader_type canvas_item;
render_mode blend_mix;

uniform float tint : hint_range(0, 2) = 2;



void fragment() {
// Input:10
	vec4 n_out10p0 = COLOR;


// Input:11
	vec2 n_out11p0 = SCREEN_UV;


// VectorOp:18
	vec2 n_in18p1 = vec2(-0.50000, -0.50000);
	vec2 n_out18p0 = n_out11p0 + n_in18p1;


// Input:13
	vec2 n_out13p0 = SCREEN_PIXEL_SIZE;


// VectorOp:20
	vec2 n_in20p1 = vec2(64.00000, 64.00000);
	vec2 n_out20p0 = n_out13p0 * n_in20p1;


// VectorOp:16
	vec2 n_out16p0 = n_out18p0 / n_out20p0;


// Input:12
	float n_out12p0 = TIME;


// FloatParameter:21
	float n_out21p0 = tint;


	vec3 n_out4p0;
// Expression:4
	n_out4p0 = vec3(0.0, 0.0, 0.0);
	{
		n_out16p0 *= 5.0;
		float r = sqrt(n_out16p0.x * n_out16p0.x + n_out16p0.y * n_out16p0.y);
		float a = atan(n_out16p0.y / n_out16p0.x);
		if (n_out16p0.x < 0.0) {
			a += PI;
		};
		n_out4p0.x = 1.0;
		n_out4p0.y = 0.0;
		n_out4p0.z = sin(r - n_out12p0) >= 0.0 ? 1.0 : (n_out21p0);
	}


	vec3 n_out14p0;
// ColorFunc:14
	{
		vec3 c = n_out4p0;
		vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
		vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
		n_out14p0 = c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
	}


// VectorOp:9
	vec4 n_out9p0 = n_out10p0 * vec4(n_out14p0, 0.0);


// Output:0
	COLOR.rgb = vec3(n_out9p0.xyz);


}
                       
    ��D  4C              !   
   蹢B�MC"   
     D  D#         0,3,v;1,0,t;2,0,tint; $      	   0,4,res; %      �   v *= 5.0;
float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
res.x = 1.0;
res.y = 0.0;
res.z = sin(r - t) >= 0.0 ? 1.0 : (tint); &            '   
    ��DB��B(            )   
     �C  pB*            +   
     ��   B,            -   
     4�  �C.            /   
    ���  �C0            1   
     CD  �C2            3   
   �W�æC4            5   
     ��  p�6         	   7   
     �    8         
   9   
     �  pC:            ;   
     R�   C<            =   
     �  D>       0   
       	                                         	      	                                                                                                                     RSRC