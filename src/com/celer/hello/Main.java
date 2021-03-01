/* Copyright CelerSMS, 2020
 * https://www.celersms.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package com.celer.hello;

import android.os.Bundle;
import android.app.Activity;
import android.graphics.Color;
import android.view.*;
import android.widget.*;

// A "Hello World" activity
public final class Main extends Activity{

   @Override
   public final void onCreate(Bundle bb){
      super.onCreate(bb);

      // Create a simple vertical layout, add an image and a static text:
      LinearLayout vertLayOut = new LinearLayout(this);
      vertLayOut.setOrientation(LinearLayout.VERTICAL);
      vertLayOut.setGravity(Gravity.CENTER_HORIZONTAL);
      vertLayOut.setBackgroundColor(Color.BLACK);
      vertLayOut.setLayoutParams(
         new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.FILL_PARENT,
            ViewGroup.LayoutParams.FILL_PARENT
         )
      );
      ImageView logo = new ImageView(this);
      logo.setPadding(20, 20, 20, 20);
      logo.setImageResource(R.mipmap.icon);
      vertLayOut.addView(logo);
      TextView txt = new TextView(this);
      txt.setPadding(20, 20, 20, 20);
      txt.setTextColor(Color.WHITE);
      txt.setText("Hello World!");
      txt.setGravity(Gravity.CENTER_HORIZONTAL);
      vertLayOut.addView(txt);
      setContentView(vertLayOut);
   }
}
