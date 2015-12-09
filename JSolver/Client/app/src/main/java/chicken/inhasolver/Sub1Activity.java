package chicken.inhasolver;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * Created by Administrator on 2015-10-25.
 */
public class Sub1Activity extends AppCompatActivity {

    Button SaveButton;
    Button HouseButton;
    ImageView recvImg;

    Bitmap bitmap;


    protected void onCreate(Bundle savedInstanceState) {
//activity 전환
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sub1);

        SaveButton = (Button) findViewById(R.id.save_button);
        HouseButton = (Button) findViewById(R.id.house);

        //received data
        Intent intent = getIntent();
        String Msg = intent.getExtras().getString("Msg");
        String fName = intent.getExtras().getString("fName");

        //Echo Message (차후에 계산 결과 값을 넣으면 된다)
        EditText recvText = (EditText) findViewById(R.id.recvText);
        recvText.setText(Msg);
        //SDcard에 데이터 종류(Type)에 따라 자동으로 분류된 저장 폴더 경로선택
        //Environment.DIRECTORY_DOWNLOADS : 사용자에의해 다운로드가 된 파일들이 놓여지는 표준 저장소

        if (chicken.inhasolver.MainActivity.flag.charAt(0) == 'G') {

            File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);


            //수신받은 이미지 표시하는 코드
            recvImg = (ImageView) findViewById(R.id.recvImg);
            bitmap = BitmapFactory.decodeFile(path.toString() + "/" + fName);
            recvImg.setImageBitmap(bitmap);


            SaveButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {


                    OutputStream os = null;
                    FileOutputStream fos = null;
                    String extStorageDirectory = Environment.getExternalStorageDirectory().toString();

                    File file = new File(extStorageDirectory, "downImage.PNG");

                    try {
                        os = new FileOutputStream(file);
                        bitmap.compress(Bitmap.CompressFormat.PNG, 100, os);
                        os.flush();
                        os.close();

                        Toast.makeText(Sub1Activity.this, "Saved", Toast.LENGTH_LONG).show();
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                        Toast.makeText(Sub1Activity.this, e.toString(), Toast.LENGTH_LONG).show();
                    } catch (IOException e) {
                        e.printStackTrace();
                        Toast.makeText(Sub1Activity.this, e.toString(), Toast.LENGTH_LONG).show();
                    }


                }

            });



        }

        HouseButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Sub1Activity.this, chicken.inhasolver.MainActivity.class);
                startActivity(intent);
                finish();
            }
        });

    }
}

