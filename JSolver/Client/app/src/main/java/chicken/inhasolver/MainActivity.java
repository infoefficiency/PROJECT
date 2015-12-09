package chicken.inhasolver;

import com.github.clans.fab.*;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    // View
   // TextView Touch;
    Button Connect;

    static EditText sendMsg;

    // Connection
    int PORT = 9990;
    String IP = "165.246.43.91";
    static Socket socket;
    static SocketAddress socketAddress;

    // Thread
    SetSocket setSocket;
    String Msg = "NOTHING";
    static String opt = "";
    String fName = "NULL~NULL~";
    String spath;
    String state;


    //   static int tmp_len = 0;
    //flags
    static public String flag = "A?";
    String url = "http://m.blog.naver.com/GuestbookList.nhn?blogId=infoefficien";
    String url2 = "http://m.blog.naver.com/infoefficien/220560098594";



    TextView tmpview;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



        Connect = (Button) findViewById(R.id.BtnConnect);

        sendMsg = (EditText) findViewById(R.id.sendText);
        tmpview = (TextView) findViewById(R.id.textView);

        //make the External repository
        state = Environment.getExternalStorageState();
        if(!state.equals(Environment.MEDIA_MOUNTED)){
            Toast.makeText(getApplication(), "SDCard Not Mounted", Toast.LENGTH_SHORT).show();
            return;
        }



        Connect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Connect.setBackground(getResources().getDrawable(R.drawable.enter_button_click2));

                if (setSocket == null) {

                    setSocket = new SetSocket(IP, PORT);
                    setSocket.start();

                    //5일동안작성함
                    try {
                        setSocket.join();
                    } catch (Exception e) {

                    }

                 //   tmpview.setText(Msg);
                    //parameter : current activity, want activity

                    if(flag.charAt(0) == 'F'){
                        Intent intent_f = new Intent(MainActivity.this, ResultActivity.class);

                        intent_f.putExtra("Msg", Msg);
                        intent_f.putExtra("fName", fName);
                        startActivity(intent_f);
                        finish();

                    }
                else {
                        Intent intent = new Intent(MainActivity.this, Sub1Activity.class);

                        intent.putExtra("Msg", Msg);
                        intent.putExtra("fName", fName);
                        startActivity(intent);
                        finish();
                    }
                } else
                    Toast.makeText(getApplicationContext(), "이미 연결 중입니다.", Toast.LENGTH_SHORT).show();
            }
        });


        //여기서부터 버튼반응
        //Combination_button, nchoosek(n개 원소, r개 조합)
        FloatingActionButton combination_button = (FloatingActionButton) findViewById(R.id.combination_button);
        combination_button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.sendText);
                String temp = et.getText().toString();
                int pos = et.getSelectionStart();
                temp = temp.substring(0, pos) + "nchoosek(n개 원소, r개 조합)" + temp.substring(pos, temp.length());
                et.setText(temp);
                et.setSelection(pos);
            }
        });
        //sigma_button, sigma(수식, 변수, 시작, 끝)
        FloatingActionButton sigma_button = (FloatingActionButton) findViewById(R.id.sigma_button);
        sigma_button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.sendText);
                String temp = et.getText().toString();
                int pos = et.getSelectionStart();
                temp = temp.substring(0, pos) + "sigma(수식, 변수, 시작, 끝)" + temp.substring(pos, temp.length());
                et.setText(temp);
                et.setSelection(pos);
            }
        });
        //integral_button, int(수식, 변수)
        FloatingActionButton integral_button = (FloatingActionButton) findViewById(R.id.integral_button);
        integral_button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.sendText);
                String temp = et.getText().toString();
                int pos = et.getSelectionStart();
                temp = temp.substring(0, pos) + "int(수식, 변수)" + temp.substring(pos, temp.length());
                et.setText(temp);
                et.setSelection(pos);
            }
        });
        //integral_definite_button, int(수식, 변수, 하한값, 상한값)
        FloatingActionButton integral_definite_button = (FloatingActionButton) findViewById(R.id.integral_definite_button);
        integral_definite_button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.sendText);
                String temp = et.getText().toString();
                int pos = et.getSelectionStart();
                temp = temp.substring(0, pos) + "int(수식, 변수, 하한값, 상한값)" + temp.substring(pos, temp.length());
                et.setText(temp);
                et.setSelection(pos);
            }
        });
        //differential_button, diff(수식, 변수, 차수)
        FloatingActionButton differential_button = (FloatingActionButton) findViewById(R.id.differential_button);
        differential_button.setOnClickListener(new Button.OnClickListener() {
            public void onClick(View v) {
                EditText et = (EditText) findViewById(R.id.sendText);
                String temp = et.getText().toString();
                int pos = et.getSelectionStart();
                temp = temp.substring(0, pos) + "diff(수식, 변수, 차수)" + temp.substring(pos, temp.length());
                et.setText(temp);
                et.setSelection(pos);
            }
        });

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);


    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();
        opt="";
        if (id == R.id.calc) {
            flag = "C?";

            // Handle the camera action
        } else if (id == R.id.eq) {
            flag = "E?";

        } else if (id == R.id.graph) {
            flag = "G?";
            Intent intent2 = new Intent(MainActivity.this, OptionActivity.class);
            startActivity(intent2);
            finish();
        } else if( id == R.id.curve){
            flag = "F?";
            Intent intent3 = new Intent(MainActivity.this, CurveFittingActivity.class);
            startActivity(intent3);
            finish();
        }  else if(id == R.id.question){
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
        } else if(id == R.id.reference){
            startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url2)));
        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }



    public class SetSocket extends Thread {
        int PORT;
        String IP;
        DataOutputStream dos;
        DataInputStream dis;

        public SetSocket(String IP, int PORT) {
            this.IP = IP;
            this.PORT = PORT;
            //global variable

            Msg = sendMsg.getText().toString();

            if(flag.charAt(0) == 'F'){
                Msg = "";
            }
            Msg = flag + opt + Msg+"#";

        }

        @Override
        public void run() {
            //접속 에러
            try {
                socket = new Socket();
                socketAddress = new InetSocketAddress(IP, PORT);

                socket.connect(socketAddress, 2000);


                dos = new DataOutputStream
                        (socket.getOutputStream());
                dis = new DataInputStream
                        (socket.getInputStream());

            } catch (Exception e) {
                e.printStackTrace();
            }


            //송신 에러
            try{
                Log.w("MainActivity", "Start Echo String");
                dos.write(Msg.getBytes());
            } catch (Exception e) {
                e.printStackTrace();
            }
            //수신 에러
            try{
                byte arr[] = new byte[1024];

                Msg = "Could not connect to the server";
                dis.read(arr);
                Msg = new String(arr);
                Log.w("MainActivity", Msg);
            } catch (Exception e) {
                e.printStackTrace();
            }
            //SDcard에 데이터 종류(Type)에 따라 자동으로 분류된 저장 폴더 경로선택
            //Environment.DIRECTORY_DOWNLOADS : 사용자에의해 다운로드가 된 파일들이 놓여지는 표준 저장소


            //파일 수신
            try{

                File path = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS);

                fName = "graph3.jpg";//임의의 파일 수신

                File inFile = new File(path, fName);
                FileOutputStream fos = new FileOutputStream(inFile);
                BufferedOutputStream bos = new BufferedOutputStream(fos);


                int len;
                int size = 20000;
                byte[] data = new byte[size];
                while ((len = dis.read(data)) != -1) {


                    bos.write(data, 0, len);

                }//read the file


                bos.close();

                dis.close();
                dos.close();
                socket.close();
                setSocket = null;
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
    }
}
