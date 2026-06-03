var _w = sprite_get_width(sprite_index) * abs(image_xscale);
var _h = sprite_get_height(sprite_index) * abs(image_yscale);
var _cx = x + _w * 0.5;
var _cy = y + _h * 0.5;
var _angle = variable_instance_exists(id, "visual_angle") ? visual_angle : image_angle;
var _offset_distance = point_distance(0, 0, _w * 0.5, _h * 0.5);
var _offset_direction = point_direction(0, 0, _w * 0.5, _h * 0.5) + _angle;

draw_sprite_ext(sprite_index, image_index, _cx - lengthdir_x(_offset_distance, _offset_direction), _cy - lengthdir_y(_offset_distance, _offset_direction), image_xscale, image_yscale, _angle, image_blend, image_alpha);
