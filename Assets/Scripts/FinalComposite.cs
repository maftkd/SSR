using UnityEngine;

public class FinalComposite : MonoBehaviour, IPostProcessLayer
{
    public Shader finalComposite;
    private Material _finalCompositeMat;

    public float xScale;
    public float yScale;
    
    // Start is called before the first frame update
    void Start()
    {
        #if UNITY_EDITOR || UNITY_EDITOR_OSX
        yScale = 1;
        #endif
        
    }

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_finalCompositeMat == null)
        {
            _finalCompositeMat = new Material(finalComposite);
        }

        RenderTexture tmp = RenderTexture.GetTemporary(destination.width, destination.height, 0, destination.format);
        //RenderTexture tmp2 = RenderTexture.GetTemporary(destination.width, destination.height, 0, destination.format);
        Graphics.Blit(null, tmp, _finalCompositeMat, 0);
        
        //Graphics.Blit(null, destination, _finalCompositeMat);
        Graphics.Blit(tmp, destination, _finalCompositeMat, 1);
        RenderTexture.ReleaseTemporary(tmp);
        
        _finalCompositeMat.SetFloat("_XScale", xScale);
        _finalCompositeMat.SetFloat("_YScale", yScale);
        //Graphics.Blit(tmp, destination, _finalCompositeMat, 2);
        //RenderTexture.ReleaseTemporary(tmp2);
        
    }
}
