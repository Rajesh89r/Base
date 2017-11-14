package com.bridgellc.bridge.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.bridgellc.bridge.R;
import com.bridgellc.bridge.stickylistview.StickyListHeadersAdapter;
import com.bridgellc.bridge.entity.NegotiateResponseEntity;
import com.bridgellc.bridge.utils.GlobalMethods;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Created by Karthi on 3/21/2016.
 */
public class NegotiationChatAdapter extends BaseAdapter implements
        StickyListHeadersAdapter, SectionIndexer {
    private Context context;
    private SimpleDateFormat mTargetDateTime = new SimpleDateFormat("hh:mm aa", Locale.US);
    private Holder viewHolder = null;
    public static ArrayList<NegotiateResponseEntity> chatStrings = new ArrayList<NegotiateResponseEntity>();
    private LayoutInflater inflater;

    private int[] mSectionIndices;
    private String[] mSectionLetters;
    public NegotiationChatAdapter(Context context, ArrayList<NegotiateResponseEntity> chat) {
        this.context = context;
        this.chatStrings = chat;
        mSectionIndices = getSectionIndices();
        mSectionLetters = getSectionLetters();
    }
    class Holder {
        TextView mTimetxt, mSubHeaderTxt;
      //  TextView left_message,right_message,leftProfile,rightProfile,leftDate,rightDate;

    }
    public View getView(int position, View convertView, ViewGroup parent) {

               inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View gridView;

        gridView = inflater .inflate(R.layout.negotiation_chat_view_item, parent, false);


        LinearLayout left_layout = (LinearLayout) gridView.findViewById(R.id.left_layout);
        RelativeLayout right_layout = (RelativeLayout) gridView.findViewById(R.id.righ_layout);

        TextView left_message = (TextView) gridView.findViewById(R.id.left_message);
        TextView right_message = (TextView) gridView.findViewById(R.id.right_message);
        TextView leftProfile = (TextView) gridView.findViewById(R.id.left_profile);
        TextView rightProfile = (TextView) gridView.findViewById(R.id.right_profile);
        TextView leftDate = (TextView) gridView.findViewById(R.id.left_date);
        TextView rightDate = (TextView) gridView.findViewById(R.id.right_date);

        if (!(chatStrings.get(position).getUser_id().equalsIgnoreCase(GlobalMethods.getUserID(context)))) {
            left_layout.setVisibility(View.VISIBLE);
            left_message.setText("$ " + GlobalMethods.getDecodedmessage(GlobalMethods.afterTwoPointVal(chatStrings.get(position).getNegitation_amount())));
            leftDate.setText(GlobalMethods.getCustomDateFormate(chatStrings.get(position).getDate_sent(), mTargetDateTime));
            leftProfile.setText(chatStrings.get(position).getUser_name());
            right_layout.setVisibility(View.GONE);
        } else {
            left_layout.setVisibility(View.GONE);
            right_layout.setVisibility(View.VISIBLE);
            rightProfile.setText(chatStrings.get(position).getUser_name());
            rightDate.setText(GlobalMethods.getCustomDateFormate(chatStrings.get(position).getDate_sent(), mTargetDateTime));
            right_message.setText("$ " + GlobalMethods.getDecodedmessage(GlobalMethods.afterTwoPointVal(chatStrings.get(position).getNegitation_amount())));
        }

        if (chatStrings.get(position) != null && chatStrings.get(position).getNegitation_amount()
                != null && chatStrings.get
                (position).getNegitation_amount()
                .equalsIgnoreCase("")) {
            left_layout.setVisibility(View.INVISIBLE);
            right_layout.setVisibility(View.INVISIBLE);
        }

        return gridView;
    }

    private String getTime(String date_sent) {
        SimpleDateFormat mResponseformat = new SimpleDateFormat("yyyy-mm-DD HH:mm:ss", Locale.US);
        SimpleDateFormat mConvertformat = new SimpleDateFormat("hh:mm aa", Locale.US);
        String mNewDate = "";

        Date mInputDate = null;
        try {
            mInputDate = mResponseformat.parse(date_sent);
            mNewDate = mConvertformat.format(mInputDate);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mNewDate;
    }

    public static String getLocalTime(String inputDate) {
        Date dateobj;
        dateobj = null;
        String dateFormateInLocalTimeZone = "";
        try {

            //create a new Date object using the UTC timezone
            SimpleDateFormat Inputformat = new SimpleDateFormat("yyyy-mm-DD HH:mm:ss", Locale.US);
            Inputformat.setTimeZone(TimeZone.getTimeZone("UTC"));
            dateobj = Inputformat.parse(inputDate);
            SimpleDateFormat displayFormat = new SimpleDateFormat("hh:mm aa", Locale.US);
            //SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss z'('Z')'");

            displayFormat.setTimeZone(TimeZone.getDefault());
            dateFormateInLocalTimeZone = displayFormat.format(dateobj);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return dateFormateInLocalTimeZone;
    }

    @Override
    public int getCount() {
        return chatStrings.size();
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }


    @Override
    public int getPositionForSection(int section) {
        if (mSectionIndices.length == 0) {
            return 0;
        }

        if (section >= mSectionIndices.length) {
            section = mSectionIndices.length - 1;
        } else if (section < 0) {
            section = 0;
        }
        return mSectionIndices[section];
    }

    @Override
    public int getSectionForPosition(int position) {
        for (int i = 0; i < mSectionIndices.length; i++) {
            if (position < mSectionIndices[i]) {
                return i - 1;
            }
        }
        return mSectionIndices.length - 1;
    }

    @Override
    public Object[] getSections() {
        return mSectionLetters;
    }
    @Override
    public View getHeaderView(int position, View view, ViewGroup parent) {

        if (view == null) {
            viewHolder = new Holder();

            view = inflater.inflate(R.layout.notification_header, parent,
                    false);

            viewHolder.mSubHeaderTxt = (TextView) view
                    .findViewById(R.id.sub_header_txt);
            view.setTag(viewHolder);
        } else {
            viewHolder = (Holder) view.getTag();
        }

        final CharSequence headerChar = chatStrings.get(position)
                .getHeaderakey();
        viewHolder.mSubHeaderTxt.setText(headerChar);


        // viewHolder.mSubHeaderTxt.setOnClickListener(new OnClickListener() {
        //
        // @Override
        // public void onClick(View v) {
        // for (int i = 0; i < mNotificList.size(); i++) {
        //
        // if (mNotificList.get(i).getHeaderakey()
        // .equalsIgnoreCase(headerChar.toString())) {
        //
        // if (mNotificList.get(i).isIsvisible()) {
        // mNotificList.get(i).setIsvisible(false);
        // } else {
        // mNotificList.get(i).setIsvisible(true);
        // }
        //
        // }
        // }
        // notifyDataSetChanged();
        //
        // }
        // });
        return view;
    }

    @Override
    public long getHeaderId(int position) {
        return chatStrings.get(position).getHeadId();

    }

    private int[] getSectionIndices() {
        int temp = 0;
        ArrayList<Integer> sectionIndices = new ArrayList<Integer>();
        String lastFirstChar = "";
        if (chatStrings.size() > 0) {
            lastFirstChar = chatStrings.get(0).getHeaderakey();
            chatStrings.get(0).setHeadId(temp);

        }

        sectionIndices.add(0);
        for (int i = 1; i < chatStrings.size(); i++) {
            if (!chatStrings.get(i).getHeaderakey()
                    .equalsIgnoreCase(lastFirstChar)) {
                lastFirstChar = chatStrings.get(i).getHeaderakey();
                sectionIndices.add(i);
                temp++;
                chatStrings.get(i).setHeadId(temp);
            } else {
                chatStrings.get(i).setHeadId(temp);
            }
        }
        int[] sections = new int[sectionIndices.size()];
        for (int i = 0; i < sectionIndices.size(); i++) {
            sections[i] = sectionIndices.get(i);
        }
        return sections;
    }

    private String[] getSectionLetters() {

        String[] letters = new String[mSectionIndices.length];
        for (int i = 0; i < mSectionIndices.length; i++) {
            if (chatStrings.size() > 0) {
                letters[i] = chatStrings.get(mSectionIndices[i])
                        .getHeaderakey();
            }

        }
        return letters;
    }
}
