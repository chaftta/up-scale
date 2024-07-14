import os
import sys
import glob
import subprocess

# アップスケール倍率の設定（2, 4, 8のいずれか）
UPSCALE_FACTOR = 4

input_dir = "/workspace/input"
output_dir = "/workspace/output"

def main():
    print("Real-ESRGANの処理を開始します...")

    # 入力ディレクトリが空かチェック
    if not any(os.scandir(input_dir)):
        print("入力ディレクトリが空です。処理する画像を追加してください。")
        sys.exit(1)

    print("入力ディレクトリにファイルが見つかりました。処理を開始します...")

    # 対象となる画像ファイルの拡張子
    extensions = ['png', 'jpg', 'jpeg', 'webp']
    
    for ext in extensions:
        for file in glob.glob(os.path.join(input_dir, f"*.{ext}")):
            filename = os.path.basename(file)
            name, extension = os.path.splitext(filename)
            
            print(f"ファイルを処理中: {filename}")
            
            command = [
                "python3", 
                "/real-esrgan/inference_realesrgan.py",
                "-n", f"RealESRGAN_x{UPSCALE_FACTOR}plus",
                "-i", file,
                "-o", output_dir,
                "--fp32",
                "-g", "-1"
            ]
            
            subprocess.run(command, check=True)
            
            print(f"処理完了: {filename}")

    print("すべての処理が完了しました。出力ディレクトリで結果を確認してください。")

if __name__ == "__main__":
    main()