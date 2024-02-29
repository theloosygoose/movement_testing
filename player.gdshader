shader_type canvas_item;
uniform bool make_white = false; //Like a variable

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if (!make_white){

	} else {
		COLOR.r = 1.0;
		COLOR.b = 1.0;
		COLOR.y = 1.0;
		
	}

}

