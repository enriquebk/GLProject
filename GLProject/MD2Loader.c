
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

