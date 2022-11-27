varying vec2 vUv;
uniform vec3 uColorA;
uniform vec3 uColorB;
uniform float time;
void main(){

vec2 uv = abs(vUv - .5) *3.;

float v = abs(sin( uv.x* 10. - time * 3.) + sin( uv.y * 10. - time* 3. ));
  vec3 col = mix( vec3(1.,.8,.8) , vec3( 1.,.9,.6), v);
  gl_FragColor = vec4(col,
    1.
  );
}