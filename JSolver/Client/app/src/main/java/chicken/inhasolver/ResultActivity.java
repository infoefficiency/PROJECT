package chicken.inhasolver;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import chicken.inhasolver.MainActivity;
/**
 * Created by Administrator on 2015-10-25.
 */
public class ResultActivity extends AppCompatActivity {

    Button SaveButton2;
    ImageView recvImg2;
    Button HouseButton2;

    Bitmap bitmap2;

    protected void onCreate(Bundle savedInstanceState) {
        //activity ��ȯ
        super.onCreate(savedInstanceState);
        setContentView(R.layout.result_main);

        SaveButton2 = (Button) findViewById(R.id.save_button2);
        HouseButton2 = (Button) findViewById(R.id.house2);
        //received data
        Intent intent = getIntent();
        String Msg = intent.getExtras().getString("Msg");
        String fName = intent.getExtras().getString("fName");
        String tmp = "";

        //Echo Message (���Ŀ� ��� ��� ���� ������ �ȴ�)
        TextView recvText2 = (TextView) findViewById(R.id.recvText2);

        int idx = 0;
        for(int i = 0; i<Msg.length(); ++i){
            if(Msg.charAt(i) == 'n') {
                tmp = tmp + Msg.substring(idx, i - 1);
                tmp = tmp + '\n';
                idx = i + 1;
                ++i;
            }
        }
        recvText2.setText(tmp);
        //SDcard�� ������ ����(Type)�� ���� �ڵ����� �з��� ���� ���� ��μ���
        //Environment.DIRECTORY_DOWNLOADS : ����ڿ����� �ٿ�ε尡 �� ���ϵ��� �������� ǥ�� �����


            File path2 = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);


            //���Ź��� �̹��� ǥ���ϴ� �ڵ�
            recvImg2 = (ImageView) findViewById(R.id.recvImg2);
            bitmap2 = BitmapFactory.decodeFile(path2.toString() + "/" + fName);
            recvImg2.setImageBitmap(bitmap2);



            SaveButton2.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    OutputStream os = null;
                    FileOutputStream fos = null;
                    String extStorageDirectory = Environment.getExternalStorageDirectory().toString();

                    File file = new File(extStorageDirectory, "downImage.PNG");

                    try {
                        os = new FileOutputStream(file);
                        bitmap2.compress(Bitmap.CompressFormat.PNG, 100, os);
                        os.flush();
                        os.close();

                        Toast.makeText(ResultActivity.this, "Saved", Toast.LENGTH_LONG).show();
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                        Toast.makeText(ResultActivity.this, e.toString(), Toast.LENGTH_LONG).show();
                    } catch (IOException e) {
                        e.printStackTrace();
                        Toast.makeText(ResultActivity.this, e.toString(), Toast.LENGTH_LONG).show();
                    }
                }

            });

        HouseButton2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent intent4 = new Intent(ResultActivity.this, MainActivity.class);
                startActivity(intent4);
                finish();
            }
        });




        }

}

