import os

root_dir = r"c:\Users\Chamitha Shelan\Desktop\ARTecX\BitOwi\packages\tencent_cloud_chat_sdk\lib"
output_file = os.path.join(root_dir, "tencent_cloud_chat_sdk.dart")

subdirs = ["models", "enum", "manager"]

with open(output_file, "w", encoding="utf-8") as f:
    f.write("library tencent_cloud_chat_sdk;\n\n")
    f.write("export 'tencent_im_sdk_plugin.dart';\n")
    
    for subdir in subdirs:
        dir_path = os.path.join(root_dir, subdir)
        if os.path.exists(dir_path):
            for file in os.listdir(dir_path):
                if file.endswith(".dart"):
                    f.write(f"export '{subdir}/{file}';\n")

print(f"Generated exports in {output_file}")
