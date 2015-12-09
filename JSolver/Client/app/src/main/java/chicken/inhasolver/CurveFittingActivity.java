
package chicken.inhasolver;

import android.app.ActionBar;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Gravity;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.ArrayList;


//  Created by Jisu on 2015-11-18.

public class CurveFittingActivity extends AppCompatActivity {

    private LinearLayout mLayout;
    private Button addPos;
    private Button nextPage;
    private TextView log;

    ScrollView scrollView;

    int k = -1, k2 = -1;
    int flag, flag2;
    int isOK=0;

    int col = 0;
    int row = 0;


    static String curve_opt1;


    ArrayList<String> applnserverinstnos = new ArrayList<String>();
    public static EditText editText[] = new EditText[100];
    public static LinearLayout linearLayout[] = new LinearLayout[100];


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.curve_fitting_main);

        mLayout = (LinearLayout)findViewById(R.id.layout);
        addPos = (Button) findViewById(R.id.addPos);
        nextPage = (Button) findViewById(R.id.nextPage);
        log = (TextView)findViewById(R.id.log);
        scrollView=(ScrollView)findViewById(R.id.scroll);

        curve_opt1 = "";

        addPos.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                isOK++;
                row++;
                try {
                    k2++;
                    flag2 = k2;
                    final LinearLayout.LayoutParams lparams2 = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);

                    linearLayout[flag2] = new LinearLayout(CurveFittingActivity.this);
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

                        editText[flag] = new EditText(CurveFittingActivity.this);
                        editText[flag].setLayoutParams(lparams);
                        editText[flag].setGravity(Gravity.CENTER);
                        editText[flag].setId(flag);
                        //editText[flag].setSelection(editText[flag].length());
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
                if(isOK > 0) {
                    col = 0;
                    for (int i = 0; i <= flag; ++i) {
                        curve_opt1 = curve_opt1 + editText[i].getText().toString() + ",";

                    }
                    isOK = 0;
                }

                Intent intent = new Intent(CurveFittingActivity.this, CurveFittingActivity2.class);
                startActivity(intent);
                finish();
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
