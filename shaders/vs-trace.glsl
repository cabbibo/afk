
uniform mat4 iModelMat;

varying vec3 vPos;
varying vec3 vNorm;
varying vec3 vCam;

varying vec3 vMNorm;
varying vec3 vMPos;

varying vec2 vUv;
varying float vNoiseVal;


uniform float _NoiseSize;
uniform float _NoiseSpeed;
uniform float _NoiseOffset;
uniform float time;

uniform float _FFTSize;
uniform float _FFTStart;

uniform vec3 _TargetPos;


uniform float _GravitySize;
uniform float _OffsetStepResolution;


uniform sampler2D t_audio;

$noise



vec4 newPos( vec3 pos, vec3 nor ){

  float n = snoise( pos  * _NoiseSize + vec3(0.,0.,1.) * _NoiseSpeed * time );


n = floor( n * _NoiseOffset * _OffsetStepResolution ) / _OffsetStepResolution;

  vec3 fPos = nor * n;
  //fPos.x = floor( fPos.x * 10. )/10.;
  //fPos.y = floor( fPos.y * 10. )/10.;
  //fPos.z = floor( fPos.z * 10. )/10.;





  return vec4( pos + fPos, n );

}

vec3 newNor( vec3 pos , vec3 nor , vec3 up ){

  vec3 x = normalize(cross(nor,up));
  vec3 y = normalize(cross(x,nor));

  float delta = .001;
  vec3 pl = pos + delta * x;
  vec3 pr = pos - delta * x;
  vec3 pd = pos + delta * y;
  vec3 pu = pos - delta * y;

  vec3 npl = newPos(pl,nor).xyz;
  vec3 npr = newPos(pr,nor).xyz;
  vec3 npu = newPos(pu,nor).xyz;
  vec3 npd = newPos(pd,nor).xyz;


  vec3 fNor = normalize(cross((npl-npr) * 100. , (npu-npd) * 100.));

  return fNor;



}

void main(){

  vUv = uv;

  vec4 newPosVal = newPos( position,normal);

  vPos = newPosVal.xyz; //newPos( position, normal );
  vNorm = newNor(position,normal,vec3(0.,1.,0.));


  vNoiseVal = newPosVal.w;

  vMNorm = normalMatrix * normal;
  vMPos = (modelMatrix * vec4( vPos , 1. )).xyz;

  float pullLength = _GravitySize;

  if( length( vMPos.xy - _TargetPos.xy) < pullLength ){

    float d =  (pullLength - length( vMPos.xy - _TargetPos.xy) )/pullLength;
    vMPos = mix( vMPos,_TargetPos,d);
  }


  //vLight = ( iModelMat * vec4(  vec3( 400. , 1000. , 400. ) , 1. ) ).xyz;


  // Use this position to get the final position 
  gl_Position = projectionMatrix *viewMatrix* vec4( vMPos , 1.);

}