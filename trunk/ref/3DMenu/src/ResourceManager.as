package
{
    import flash.utils.ByteArray;
    import org.papervision3d.materials.MovieMaterial;

    public class ResourceManager
    {
        [Embed (source="../media/fighter1.dae", mimeType="application/octet-stream")]
        public static const Fighter1:Class;
        public static const Fighter1XML:XML = function():XML{var byteArray:ByteArray = new Fighter1() as ByteArray; return new XML(byteArray.readUTFBytes(byteArray.length));}();

        [Embed (source="../media/sf-02.jpg")]
        public static const SF02:Class;
        public static const SF02_Tex:MovieMaterial = new MovieMaterial(new SF02());
    }
}
