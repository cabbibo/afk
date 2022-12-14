

uniform float time;
uniform sampler2D t_audio;

uniform sampler2D t_matcap;
uniform sampler2D t_normal;
uniform sampler2D t_text;

uniform float _HueSize;
uniform float _HueStart;


uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;


varying vec3 vPos;
varying vec3 vCam;
varying vec3 vNorm;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;
varying float vNoiseVal;

vec3 bulbPos[5];


$uvNormalMap
$semLookup
$hsv





uniform float _FFTSize;
uniform float _FFTStart;
uniform float _Saturation;
uniform float _Lightness;
uniform float _NoiseOffset;
uniform float _NormalDepth;
uniform float _DiscardAmount;

uniform float _Opacity;
uniform float _OpacityFalloffSpeed;

void main(){

  vec3 fNorm = uvNormalMap( t_normal , vPos , vUv , vNorm , 4.   , .5 * _NormalDepth);

  vec3 ro = vPos;
  vec3 rd = normalize( vPos - vCam );

  vec3 p = vec3( 0. );
  vec3 col =  vec3( 0. );

  float m = max(0.,dot( -rd , fNorm ));
    //vec4 audio = texture2D(t_audio,vec2(vNoiseVal * _FFTSize + _FFTStart,0.));
  
  vec3 mat = texture2D( t_matcap , semLookup( rd , fNorm , modelViewMatrix , normalMatrix ) ).xyz;


  if( sin(vNoiseVal * 20. ) < _DiscardAmount ){
    //discard;
  }
 
 
 
  col.xyz = hsv( _HueStart + _HueSize * vNoiseVal * _NoiseOffset * 1000., _Saturation,_Lightness);// * mat;// * audio.xyz;//mat;
  //col += fNorm * .5 + .5;

  float multiplier = clamp(1./abs(vNoiseVal *_OpacityFalloffSpeed),0.,1.);
  col *= multiplier;






  gl_FragColor = vec4( clamp(col,vec3(0.),vec3(1.)) ,_Opacity * multiplier );

}










