shader_type canvas_item;
uniform float script_speed;

void fragment(){
    COLOR = texture(TEXTURE, vec2(UV.x + script_speed, UV.y));
}