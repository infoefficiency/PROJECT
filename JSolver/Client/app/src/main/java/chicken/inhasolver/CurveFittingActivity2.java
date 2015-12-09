
package chicken.inhasolver;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;


//  Created by Jisu on 2015-11-18.

public class CurveFittingActivity2 extends AppCompatActivity {

    private LinearLayout mLayout;
    private Button addPos;
    private Button nextPage;
    private TextView log;
    private EditText polynum;

    ScrollView scrollView;
    RadioGroup rg1;


    int k = -1, k2 = -1;
    int flag, flag2;
    int isOK=0;


    static String curve_opt2;
    static String polyopt;

    ArrayList<String> applnserverinstnos = new ArrayList<String>();
    public static EditText editText[] = new EditText[100];
    public static LinearLayout linearLayout[] = new LinearLayout[100];


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.curve_fitting_main2);

        mLayout = (LinearLayout)findViewById(R.id.layout);
        addPos = (Button) findViewById(R.id.addPos);
        nextPage = (Button) findViewById(R.id.nextPage);
        log = (TextView)findViewById(R.id.log);
        scrollView=(ScrollView)findViewById(R.id.scroll);
        polynum = (EditText)findViewById(R.id.polynum);
        rg1 = (RadioGroup) findViewById(R.id.group);


        curve_opt2 = "";

        polyopt = "smoothingspline";




        addPos.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                isOK++;
                try {
                    k2++;
                    flag2 = k2;
                    final LinearLayout.LayoutParams lparams2 = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);

                    linearLayout[flag2] = new LinearLayout(CurveFittingActivity2.this);
                    linearLayout[flag2].setLayoutParams(lparams2);
                    linearLayout[flag2].setOrientation(LinearLayout.HORIZONTAL);
                    linearLayout[flag2].setId(flag);
                } catch(Exception e){
                    e.printStackTrace();
                }

                for(int i = 0; i<3; ++i) {
                    try {
                        k++;
                        flag = k;
                        final LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(120, LinearLayout.LayoutParams.MATCH_PARENT);
                        lparams.setMargins(40, 20, 5, 0);

                        editText[flag] = new EditText(CurveFittingActivity2.this);
                        editText[flag].setLayoutParams(lparams);
                        editText[flag].setGravity(Gravity.CENTER);
                        editText[flag].setId(flag);
                        editText[flag].setSelection(editText[flag].length());
                        editText[flag].setCursorVisible(false);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    linearLayout[flag2].addView(editText[flag]);
                }
                mLayout.addView(linearLayout[flag2]);
                scrollToEnd();
            }
        });


        nextPage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isOK > 0) {

                    for (int i = 0; i <= flag; ++i) {
                        curve_opt2 = curve_opt2 + editText[i].getText().toString() + ",";
                    }
                    isOK = 0;
                }



                MainActivity.flag = MainActivity.flag + CurveFittingActivity.curve_opt1 + "?" + CurveFittingActivity2.curve_opt2 + "?" + CurveFittingActivity2.polyopt +
                        polynum.getText().toString()+"?";
              //  log.setText(CurveFittingActivity.curve_opt1 + CurveFittingActivity2.curve_opt2 + CurveFittingActivity2.polyopt );

                Intent intent = new Intent(CurveFittingActivity2.this, MainActivity.class);
                startActivity(intent);
                finish();
            }
        });


       rg1.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
           @Override
           public void onCheckedChanged(RadioGroup group, int checkedId) {
               switch (checkedId) {
                   case R.id.bt1:

                       polyopt = "poly" ;
                       break;
                   case R.id.bt2:
                       polyopt = "smoothingspline";
                       break;
                   case R.id.bt3:
                       polyopt = "lowess";
                       break;
                   case R.id.bt4:
                       polyopt = "exp1";
                       break;
               }
           }
       });

    }

    public void scrollToEnd(){
        scrollView.post(new Runnable(){
            @Override
            public void run(){
                scrollView.fullScroll(View.FOCUS_DOWN);
            }
        });
    }





}
