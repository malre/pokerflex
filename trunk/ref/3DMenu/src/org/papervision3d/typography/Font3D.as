package org.papervision3d.typography {	import org.papervision3d.materials.special.VectorShapeMaterial;			/**	 * @author Mark Barcinski	 */	public class Font3D {		public function get motifs():Object		{			//Override me			return new Object();		}				public function get widths():Object		{			//Override me			return new Object();		}				public function get height():Number		{ 			//Override me			return -1;		}			}}