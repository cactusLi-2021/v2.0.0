#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zip.h>

int main()
{
        char *path = "./1.zip";
        int err = 0;
        zip_t *archive = NULL;
        zip_file_t *file = NULL;
        zip_source_t *source;
        int n = 0;

        //��zipѹ���ļ�
        archive = zip_open(path, ZIP_CREATE, &err);
        if(archive == NULL)
        {
                printf("open 1.zip failed, err=%d\n", err);
                return -1;
        }

        //��zip�ļ�����ļ���
        zip_add_dir(archive, "11");

        //��zip�ļ�����ļ�
        source = zip_source_file(archive, "11/1.txt", 0, -1);
        zip_add(archive, "11/1.txt", source);

        //�ر�ѹ���ļ�
        zip_close(archive);

        return 0;
}