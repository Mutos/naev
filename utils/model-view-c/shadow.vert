uniform mat4 projection = mat4(
   1.0, 0.0, 0.0, 0.0,
   0.0, 1.0, 0.0, 0.0,
   0.0, 0.0, 1.0, 0.0,
   0.0, 0.0, 0.0, 1.0 );
uniform mat4 model = mat4(
   1.0, 0.0, 0.0, 0.0,
   0.0, 1.0, 0.0, 0.0,
   0.0, 0.0, 1.0, 0.0,
   0.0, 0.0, 0.0, 1.0 );

in vec3 vertex;

/* Not including math.glsl here because a python script reads this also and
can't handle include preprocessor. */
const float M_PI        = 3.14159265358979323846;  /* pi */

const float view_angle = -M_PI / 4.0;
const mat4 view = mat4(
      1.0,             0.0,              0.0, 0.0,
      0.0,  cos(view_angle), sin(view_angle), 0.0,
      0.0, -sin(view_angle), cos(view_angle), 0.0,
      0.0,             0.0,              0.0, 1.0 );

void main (void)
{
   gl_Position = projection * pos * view * model * vec4( vertex, 1.0 );
}
