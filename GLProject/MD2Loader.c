
#include "MD2Loader.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int readMd2File (const char *filename, struct Md2_model *modelo)
{
  FILE *fp;
  int i;

  fp = fopen (filename, "rb");
  if (!fp)
    {
      fprintf (stderr, "Error: couldn't open \"%s\"!\n", filename);
      return 0;
    }

  //Leo la cabezera md2 del modelo
  //apartir de estos datos puedo saber donde se encuentran, en el archivo, los datos de los triangulos, vertices, etc.. 
  fread (&modelo->header, 1, sizeof (struct Md2_header), fp);

  modelo->texturas = (struct Md2_textura *) malloc (sizeof (struct Md2_textura) * modelo->header.num_texturas);
  modelo->texcoords = (struct Md2_texCoord *) malloc (sizeof (struct Md2_texCoord) * modelo->header.num_uv);
  
  modelo->triangles = (struct Md2_triangle *) malloc (sizeof (struct Md2_triangle) * modelo->header.num_triangulos);
    modelo->frames = (struct Md2_frame *) malloc (sizeof (struct Md2_frame) * modelo->header.num_frames);
  modelo->glcmds = NULL;

  /* Cargo el modelo con el archivo */
  
  //me posiciono en el archivo para poder leer la textura del archivo
  fseek (fp, modelo->header.desplazamiento_texturas, SEEK_SET);
  //leeo la texutra del archivo y la guardo en el modelo auxiliar 
  fread (modelo->texturas, sizeof (struct Md2_textura), modelo->header.num_texturas, fp);

  //me posiciono en el archivo segun el desplazamiento de las coordenadas de texturas, para luego poder leerlas
  fseek (fp, modelo->header.desplazamiento_st, SEEK_SET);
  //leeo las coordenadas de textura del archivo y las guardo en el array de coordenadas del modelo
  fread (modelo->texcoords, sizeof (struct Md2_texCoord), modelo->header.num_uv, fp);

  //me posiciono en el archivo segun el desplazamiento de los triangulos, para luego poder leerlos
  
  fseek (fp, modelo->header.desplazamiento_triangulos, SEEK_SET);
  //leeo los triangulos del archivo y las guardo en el array de triangulos del modelo
  fread (modelo->triangles, sizeof (struct Md2_triangle), modelo->header.num_triangulos, fp);

  /* Leo los frames del modelo */
  
  //me posisiono en el archivo segun el desplazamiento de frames, para luego poder leerlos
  fseek (fp, modelo->header.desplazamiento_frames, SEEK_SET);
  
  //obtengo el numero de frames del objeto partir de la cabezera
  int cantidad_de_frames =  modelo->header.num_frames;
	for (i = 0; i < cantidad_de_frames; ++i)
    {
	  //leo y guardo cada uno de los frames del archivo en el array de frames.
		
      modelo->frames[i].verts = (struct Md2_vertex *)
	 
	  malloc (sizeof (struct Md2_vertex) * modelo->header.num_vertices);

      fread (modelo->frames[i].scale, sizeof (_Vec3), 1, fp);
  
      fread (modelo->frames[i].translate, sizeof (_Vec3), 1, fp);
  
      fread (modelo->frames[i].name, sizeof (char), 16, fp);
    
    
      fread (modelo->frames[i].verts, sizeof (struct Md2_vertex), modelo->header.num_vertices, fp);
    }
  fclose (fp);
  return 1;
}


void FreeModel (struct Md2_model *modelo)
{
  int i;

  if (modelo->texturas)
    {
      free (modelo->texturas);
      modelo->texturas = NULL;
    }

  if (modelo->texcoords)
    {
      free (modelo->texcoords);
      modelo->texcoords = NULL;
    }

  if (modelo->triangles)
    {
      free (modelo->triangles);
      modelo->triangles = NULL;
    }

  if (modelo->glcmds)
    {
      free (modelo->glcmds);
      modelo->glcmds = NULL;
    }

  if (modelo->frames)
    {
      for (i = 0; i < modelo->header.num_frames; ++i)
	{
	  free (modelo->frames[i].verts);
	  modelo->frames[i].verts = NULL;
	}

      free (modelo->frames);
      modelo->frames = NULL;
    }
}
/*
Object3D* obj_from_MD2(const char* filename){
	
	if (!LeerModeloMd2 (filename, &modeloAuxiliar))
		exit (EXIT_FAILURE);
	
	struct Md2_model *pModeloAuxiliar = &modeloAuxiliar;
	
	Object3D* object=(Object3D*)cg_malloc(sizeof(Object3D));
	
	object->frame_index= 0.0f;
	
	object->frames = array_with_capacity(pModeloAuxiliar->header.num_frames);
	
	MATRIX4_MAKE_IDENT(object->modelMatrix);
	
	object->texture = NULL;
	
	object->normals_loaded = 1;
	
	int i = 0;
	for(i = 0; i< object->frames->capacity; i++){
		
		Mesh* mesh=(Mesh*)cg_malloc(sizeof(Mesh));
		mesh->vertexs = array_with_capacity(pModeloAuxiliar->header.num_vertices); 
		mesh->triangles = array_with_capacity( pModeloAuxiliar->header.num_triangulos);
		mesh->texCoords = array_with_capacity( pModeloAuxiliar->header.num_uv); 
	
		int j= 0;
	
		for(j = 0; j< mesh->triangles->capacity; j++){
			
			struct Md2_triangle *ptri;
	        ptri = &(pModeloAuxiliar->triangles[j]);
			
			Triangle3D* t = (Triangle3D*)cg_malloc(sizeof(Triangle3D));
			t->vertex1_index = (unsigned int ) ptri->vertex[0];
			t->vertex2_index = (unsigned int ) ptri->vertex[1];
			t->vertex3_index = (unsigned int ) ptri->vertex[2];
			
			t->vertex1_uv_index = ptri->st[0];
			t->vertex2_uv_index = ptri->st[1];
			t->vertex3_uv_index = ptri->st[2];
			
			array_add(mesh->triangles, t);
		}
		for(j = 0; j< mesh->vertexs->capacity; j++){

			struct Md2_frame *pframe;
			struct Md2_vertex *pvert;
			
		    pframe = &(pModeloAuxiliar->frames[i]);
	        pvert = &(pframe->verts[j]);

			Vertex* vrxt = (Vertex*)cg_malloc(sizeof(Vertex));
			vrxt->pos = (Vec4){ (float)((pframe->scale[0] * pvert->v[0]) + pframe->translate[0]),
								(float)((pframe->scale[1] * pvert->v[1]) + pframe->translate[1]),
								(float)((pframe->scale[2] * pvert->v[2]) + pframe->translate[2]),
								1.0f};
			
			vrxt->normal = (Vec4){  anorms_table[pvert->normalIndex][0],
									anorms_table[pvert->normalIndex][1],
									anorms_table[pvert->normalIndex][2],
									0.0f};
									
			array_add(mesh->vertexs, vrxt);
		}
		
		for(j = 0; j< mesh->texCoords->capacity; j++){
			
			struct Md2_triangle *ptri;
	        ptri = &(pModeloAuxiliar->triangles[j]);
			
			TexCoord* tc = (TexCoord*)cg_malloc(sizeof(TexCoord));
			tc->u = (float)pModeloAuxiliar->texcoords[j].u / pModeloAuxiliar->header.ancho_textura;
			tc->v = (float)pModeloAuxiliar->texcoords[j].v / pModeloAuxiliar->header.alto_textura;
			
			array_add(mesh->texCoords, tc);
		}
		
		array_add(object->frames, mesh);
	}
	
	FreeModel (&modeloAuxiliar);
		
	return object;
}*/

