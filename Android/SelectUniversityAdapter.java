package com.bridgellc.bridge.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bridgellc.bridge.R;
import com.bridgellc.bridge.entity.UniversityEntity;
import com.bridgellc.bridge.utils.AppConstants;

import java.util.ArrayList;

public class SelectUniversityAdapter extends BaseAdapter {

    private Context mContext;
    private Holder viewHolder;
    private ArrayList<UniversityEntity> mUniversityList;
    private int mSelectedPos = -1;
    private ImageView mSelectImg[];
    private boolean oldUniversityId = true;

    public SelectUniversityAdapter(Context mContext,
                                   ArrayList<UniversityEntity> universityList) {
        this.mContext = mContext;
        this.mUniversityList = universityList;
        this.mSelectImg = new ImageView[universityList.size()];
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

//        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.select_university_adapter, parent, false);
            viewHolder = new Holder(convertView);

            convertView.setTag(viewHolder);
//        } else {
            viewHolder = (Holder) convertView.getTag();
//        }
        viewHolder.mUniversityNameTxt.setText(mUniversityList.get(position).getUniversity_name());
        mSelectImg[position] = viewHolder.mRightImg;
        viewHolder.mUnivSelectLay.setTag(position);
        mSelectImg[position].setTag(position);


        if (!AppConstants.SELECT_SCH_UNI_ID.equalsIgnoreCase(mContext.getString(R.string.zero))&&oldUniversityId) {

                for (int i = 0; i < mUniversityList.size(); i++) {
                    if (AppConstants.SELECT_SCH_UNI_ID.equalsIgnoreCase(mUniversityList.get(i).getUniversity_id())) {
                        mSelectedPos = i;
                        oldUniversityId = false;
                        break;
                    }
                }


        }

        if (mSelectedPos != -1&&mSelectedPos==position) {
            mSelectImg[position].setVisibility(View.VISIBLE);
        } else {
            mSelectImg[position].setVisibility(View.GONE);
        }


        viewHolder.mUnivSelectLay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                for (int i = 0; i < mSelectImg.length
                        && mSelectImg[i] != null; i++) {
                    if (mSelectImg[i].getTag() == v.getTag()) {
                        mSelectImg[i]
                                .setImageResource(R.drawable.tick_gray_img);
                        AppConstants.SELECT_SCH_UNI = mUniversityList.get(i).getUniversity_name();
                        AppConstants.SELECT_SCH_UNI_ID = mUniversityList.get(i).getUniversity_id();
                        mSelectImg[i].setVisibility(View.VISIBLE);
                    } else {
                        mSelectImg[i].setVisibility(View.GONE);
                    }
                }
            }
        });

        return convertView;

    }

    class Holder {
        ImageView mRightImg;
        RelativeLayout mUnivSelectLay;
        TextView mUniversityNameTxt;

        public Holder(View mView) {
            mRightImg = (ImageView) mView.findViewById(R.id.right_img);
            mUniversityNameTxt = (TextView) mView.findViewById(R.id.university_name_txt);
            mUnivSelectLay = (RelativeLayout) mView.findViewById(R.id.univ_select_lay);
        }
    }

    @Override
    public int getCount() {
        return mUniversityList.size();
    }

    @Override
    public Object getItem(int position) {
        return mUniversityList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }
}
