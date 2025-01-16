using UnityEngine;

public class ScreenSpaceReflection : MonoBehaviour, IPostProcessLayer
{
    public Shader shader;
    private Material _mat;
    private RenderTexture _reflectionTexture;

    [Range(1, 100)]
    public float maxDistance;
    /*
    [Range(0.01f, 1)]
    public float resolution;
    [Range(1, 20)]
    public int steps;
    */
    [Range(0.01f, 10)]
    public float thickness;
    [Range(0, 0.1f)] 
    public float noise;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (_mat == null)
        {
            _mat = new Material(shader);
        }
        if(_reflectionTexture == null || _reflectionTexture.width != dest.width || _reflectionTexture.height != dest.height)
        {
            if (_reflectionTexture != null)
            {
                _reflectionTexture.Release();
            }
            _reflectionTexture = new RenderTexture(dest.width, dest.height, 0, RenderTextureFormat.ARGB32);
            _reflectionTexture.wrapMode = TextureWrapMode.Clamp;
            Shader.SetGlobalTexture("_ReflectionTexture", _reflectionTexture);
        }
        
        _mat.SetFloat("_MaxDistance", maxDistance);
        //_mat.SetFloat("_Resolution", resolution);
        //_mat.SetInt("_Steps", steps);
        _mat.SetFloat("_Thickness", thickness);
        _mat.SetFloat("_Noise", noise);
        
        Graphics.Blit(null, _reflectionTexture, _mat);
    }
}
