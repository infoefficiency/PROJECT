package chicken.inhasolver;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

/**
 * Created by Jisu on 2015-11-13.
 */

public class OptionActivity extends AppCompatActivity {

    // View

    Button TotheMain;
    EditText StartX;
    EditText EndX;
    EditText StartY;
    EditText EndY;
    EditText TitleX;
    EditText TitleY;
    EditText TitleTot;

    // Option
    String Sx, Ex, Sy, Ey, Tx, Ty, Tt;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        this.setContentView(R.layout.option_main);

        TotheMain = (Button) findViewById(R.id.TotheMain);
        StartX = (EditText) findViewById(R.id.RangXEdit);
        EndX = (EditText) findViewById(R.id.RangXEdit2);
        StartY = (EditText) findViewById(R.id.RangYEdit);
        EndY = (EditText) findViewById(R.id.RangYEdit2);
        TitleX = (EditText) findViewById(R.id.TitleX);
        TitleY = (EditText) findViewById(R.id.TitleY);
        TitleTot = (EditText) findViewById(R.id.TitleTot);

        TotheMain.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                System.out.println("In override!!");

                Sx = StartX.getText().toString();
                Ex = EndX.getText().toString();
                Sy = StartY.getText().toString();
                Ey = EndY.getText().toString();
                Tx = TitleX.getText().toString();
                Ty = TitleY.getText().toString();
                Tt = TitleTot.getText().toString();

                String pos = Sx + "," + Ex + "," + Sy + "," + Ey;
                String Title = Tx + "?" + Ty + "?" + Tt;
                chicken.inhasolver.MainActivity.opt= pos + "?" + Title + "?";

                Intent intent = new Intent(OptionActivity.this, chicken.inhasolver.MainActivity.class);
                startActivity(intent);
                finish();
            }
        });

    }



}