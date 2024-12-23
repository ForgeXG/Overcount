RSRC                    VisualShader            ��������                                            ^      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    linked_parent_graph_frame    input_name    script    size    expression    op_type 	   operator    parameter_name 
   qualifier    default_value_enabled    default_value    hint    min    max    step    type 	   function 
   condition 	   constant    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    flags/world_vertex_coords    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/2/node    nodes/fragment/2/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/3/size    nodes/fragment/3/input_ports    nodes/fragment/3/output_ports    nodes/fragment/3/expression    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/5/node    nodes/fragment/5/position    nodes/fragment/6/node    nodes/fragment/6/position    nodes/fragment/7/node    nodes/fragment/7/position    nodes/fragment/8/node    nodes/fragment/8/position    nodes/fragment/9/node    nodes/fragment/9/position    nodes/fragment/10/node    nodes/fragment/10/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/2/node    nodes/start/2/position    nodes/start/3/node    nodes/start/3/position    nodes/start/4/node    nodes/start/4/position    nodes/start/7/node    nodes/start/7/position    nodes/start/8/node    nodes/start/8/position    nodes/start/12/node    nodes/start/12/position    nodes/start/13/node    nodes/start/13/position    nodes/start/13/size    nodes/start/13/input_ports    nodes/start/13/output_ports    nodes/start/13/expression    nodes/start/14/node    nodes/start/14/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections        $   local://VisualShaderNodeInput_stsgw       )   local://VisualShaderNodeExpression_d3oqv B      '   local://VisualShaderNodeVectorOp_h7ecl }      -   local://VisualShaderNodeColorParameter_857qx �      '   local://VisualShaderNodeVectorOp_xal1h Y      $   local://VisualShaderNodeInput_d04j5 �      -   local://VisualShaderNodeFloatParameter_6rx4u �      $   local://VisualShaderNodeInput_bcfot W      '   local://VisualShaderNodeVectorOp_i4ukp �      '   local://VisualShaderNodeVectorOp_rarlo       '   local://VisualShaderNodeVectorOp_wrr16 �      &   local://VisualShaderNodeCompare_cpsh0 �      .   local://VisualShaderNodeVectorDecompose_2xhwd r      '   local://VisualShaderNodeVectorOp_fwy7m �      ,   local://VisualShaderNodeFloatConstant_2t6rb 7      )   local://VisualShaderNodeExpression_aua4v q      $   local://VisualShaderNodeInput_6f2b3 �      +   res://shaders/overlays/sh_o_clockwise.tres �         VisualShaderNodeInput             uv          VisualShaderNodeExpression       
     D  D	      �   v.y -= 1.0 / 16.0;
float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
a += PI / 2.0;
float wiggle = sin(t);
if (lim >= 2.0 * PI - 0.1) {
	wiggle = 0.0;
}
res = (a <= lim + wiggle / 10.0);
res = res;          VisualShaderNodeVectorOp                                                                
                  VisualShaderNodeColorParameter             col                              �?         VisualShaderNodeVectorOp                    
                 
      �   �
                   VisualShaderNodeInput             time          VisualShaderNodeFloatParameter             anglelimit                �?         VisualShaderNodeInput             color          VisualShaderNodeVectorOp                                                                
                           VisualShaderNodeVectorOp                                                                
                  VisualShaderNodeVectorOp                                            ���=���=���=                  VisualShaderNodeCompare                                              )   �������?                   VisualShaderNodeVectorDecompose                    
           
                   VisualShaderNodeVectorOp                    
                 
           
                   VisualShaderNodeFloatConstant          ���=         VisualShaderNodeExpression       
   9�D7	sC	      �   res = sin(x * sqrt(float(3)) + y) * sin(x * sqrt(float(3)) - y) * sin(y * float(2));
res *= sin(2.0 * x * sqrt(float(3)) + 2.0 * y) * sin(2.0 * x * sqrt(float(3)) - 2.0 * y) * sin(2.0 * y * float(2));          VisualShaderNodeInput             index          VisualShader 2         B  shader_type canvas_item;
render_mode blend_mix;

uniform float anglelimit = 1.04700005054474;
uniform vec4 col : source_color = vec4(0.000000, 0.000000, 0.000000, 1.000000);



void fragment() {
// Input:9
	vec4 n_out9p0 = COLOR;


// Input:2
	vec2 n_out2p0 = UV;


// VectorOp:6
	vec2 n_in6p1 = vec2(-0.50000, -0.50000);
	vec2 n_out6p0 = n_out2p0 + n_in6p1;


// Input:7
	float n_out7p0 = TIME;


// FloatParameter:8
	float n_out8p0 = anglelimit;


	bool n_out3p0;
// Expression:3
	n_out3p0 = false;
	{
		n_out6p0.y -= 1.0 / 16.0;
		float r = sqrt(n_out6p0.x * n_out6p0.x + n_out6p0.y * n_out6p0.y);
		float a = atan(n_out6p0.y / n_out6p0.x);
		if (n_out6p0.x < 0.0) {
			a += PI;
		};
		a += PI / 2.0;
		float wiggle = sin(n_out7p0);
		if (n_out8p0 >= 2.0 * PI - 0.1) {
			wiggle = 0.0;
		}
		n_out3p0 = (a <= n_out8p0 + wiggle / 10.0);
		n_out3p0 = n_out3p0;
	}


// ColorParameter:5
	vec4 n_out5p0 = col;


// VectorOp:4
	vec4 n_out4p0 = vec4(n_out3p0 ? 1.0 : 0.0) + n_out5p0;


// VectorOp:10
	vec4 n_out10p0 = n_out9p0 * n_out4p0;


// Output:0
	COLOR.rgb = vec3(n_out10p0.xyz);


}
                    "   
     fD   C#             $   
     p�  \C%            &   
   ���d�'C'   
     D  D(         0,3,v;1,0,t;2,0,lim; )      	   0,6,res; *      �   v.y -= 1.0 / 16.0;
float r = sqrt(v.x * v.x + v.y * v.y);
float a = atan(v.y / v.x);
if (v.x < 0.0) {
	a += PI;
};
a += PI / 2.0;
float wiggle = sin(t);
if (lim >= 2.0 * PI - 0.1) {
	wiggle = 0.0;
}
res = (a <= lim + wiggle / 10.0);
res = res; +            ,   
     �C  �B-            .   
     pB  4D/            0   
     �  C1            2   
     k�  �C3            4   
     a�  �C5            6   
     �    7            8   
     /D   B9       $                                                                                    	       
       
                      
      <   
    @E   �=         	   >   
   ���D����?         
   @   
   �x�D��NBA            B   
   ���D��NBC            D   
   ��*DgU�AE            F   
     �C    G            H   
   �x�D��SCI            J   
   ��D��NBK   
   9�D7	sCL         0,0,x;1,0,y; M      	   0,0,res; N      �   res = sin(x * sqrt(float(3)) + y) * sin(x * sqrt(float(3)) - y) * sin(y * float(2));
res *= sin(2.0 * x * sqrt(float(3)) + 2.0 * y) * sin(2.0 * x * sqrt(float(3)) - 2.0 * y) * sin(2.0 * y * float(2)); O            P   
   {4C�p�BQ                                                                                                              RSRC