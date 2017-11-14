package com.bridgellc.bridge.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RatingBar;
import android.widget.TextView;

import com.bridgellc.bridge.R;
import com.bridgellc.bridge.apiinterface.APIRequestHandler;
import com.bridgellc.bridge.entity.HomeSingleItemEntity;
import com.bridgellc.bridge.main.BaseActivity;
import com.bridgellc.bridge.ui.NegotiationChatRoom;
import com.bridgellc.bridge.ui.OtherUserProfile;
import com.bridgellc.bridge.ui.RequestBiddingScreen;
import com.bridgellc.bridge.ui.ReviewScreen;
import com.bridgellc.bridge.utils.AppConstants;
import com.bridgellc.bridge.utils.DialogManager;
import com.bridgellc.bridge.utils.DialogManagerTwoBtnCallback;
import com.bridgellc.bridge.utils.DialogMangerOkCallback;
import com.bridgellc.bridge.utils.GlobalMethods;
import com.bridgellc.bridge.utils.TypefaceSingleton;
import com.bumptech.glide.Glide;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Locale;

/**
 * Created by Dell on 3/22/2016.
 */
public class RequestBiddingAdapter extends BaseAdapter {

    private Context context;

    private SimpleDateFormat mTargetDateTime = new SimpleDateFormat("MM-dd-yyyy", Locale.US);

    ArrayList<HomeSingleItemEntity> mAdapRes;
    private Holder viewHolder;
    private Typeface mLightFont, mRegulartFont;

    public RequestBiddingAdapter(Context context, ArrayList<HomeSingleItemEntity> mRes) {

        this.context = context;
        this.mAdapRes = mRes;
        this.mLightFont = TypefaceSingleton.getTypeface().getLightFont(context);
        this.mRegulartFont = TypefaceSingleton.getTypeface().getRegularFont(context);


    }

    @Override
    public int getCount() {
        return mAdapRes.size();
    }

    @Override
    public Object getItem(int position) {
        return mAdapRes.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);


            convertView = inflater.inflate(R.layout.adapter_req_bidding, parent,
                    false);
            viewHolder = new Holder(convertView);

            convertView.setTag(viewHolder);
        } else {
            viewHolder = (Holder) convertView.getTag();
        }


        viewHolder.mNameTxt.setText(mAdapRes.get(position).getUser_first_name());
//        viewHolder.mProductNameTxt.setText(mAdapRes.get(position).getItem_name());
        viewHolder.mProductPriceTxt.setText(context.getString(R.string.dollar_sym) + GlobalMethods.getPriValWithTwoPoint(mAdapRes.get(position).getBid_amount(),false));

        viewHolder.mRating_bar.setRating(Float.valueOf(mAdapRes.get(position).getUser_rating()));

        viewHolder.mDateTxt.setText(GlobalMethods.getCustomDateFormate(mAdapRes.get(position).getDate_time(), mTargetDateTime));

//        viewHolder.mAccBtn.setTag(mAdapRes.get(position));

//        if (mAdapRes.get(position).getItem_mode().equalsIgnoreCase("1")) {
//            viewHolder.mProductPriceTxt.setBackgroundResource(R.drawable.home_blue_small);
//        } else {
//            viewHolder.mProductPriceTxt.setBackgroundResource(R.drawable.home_green_small);
//        }

        try {
            if (mAdapRes.get(position).getPicture1() != null && !mAdapRes.get(position).getPicture1().equalsIgnoreCase("")) {
                Glide.with(context)
                        .load(mAdapRes.get(position).getPicture1())
                        .asBitmap().into(viewHolder.mProductImg);
            } else if (mAdapRes.get(position).getPicture2() != null && !mAdapRes.get(position).getPicture2().equalsIgnoreCase("")) {
                Glide.with(context)
                        .load(mAdapRes.get(position).getPicture2())
                        .asBitmap().into(viewHolder.mProductImg);
            } else if (mAdapRes.get(position).getPicture3() != null && !mAdapRes.get(position).getPicture3().equalsIgnoreCase("")) {
                Glide.with(context)
                        .load(mAdapRes.get(position).getPicture3())
                        .asBitmap().into(viewHolder.mProductImg);
            }
        } catch (Exception e) {

        }
        TagClass tagClass = new TagClass();
        tagClass.mtag = mAdapRes.get(position);
        viewHolder.mAccBtn.setTag(tagClass);
        viewHolder.mRejectBtn.setTag(tagClass);
        viewHolder.mNegtn.setTag(tagClass);
        viewHolder.mNameTxt.setTag(tagClass);
        viewHolder.mRating_bar.setTag(tagClass);

        viewHolder.mAccBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final TagClass pos = (TagClass) v.getTag();


//                if (pos.mtag.getPayment_mode().equalsIgnoreCase(context.getString(R.string.three))) {

                Double m = Double.valueOf(pos.mtag.getBid_amount()) * Double.valueOf(pos.mtag.getQuantity());
                DialogManager.shownAlertDialogProductPrice(context, context.getString(R.string.app_name), context.getString(R.string.do_you_acc), String.valueOf(m), new DialogMangerOkCallback() {
                    @Override
                    public void onOkClick() {

                        RequestBiddingScreen.callPaypalPayment(pos.mtag,context);
                    }
                });
//                } else {
//                    if (GlobalMethods.getStringValue(context, AppConstants.CARD_DETAILS).equalsIgnoreCase(context.getString(R.string.one))) {
//                        DialogManager.shownAlertDialogProductPrice(context, context.getString(R.string.app_name), context.getString(R.string.do_you_acc), pos.mtag.getBid_amount(), new DialogMangerOkCallback() {
//                            @Override
//                            public void onOkClick() {
//                                APIRequestHandler.getInstance().getAcceptBiddingResponse(pos.mtag.getItem_id(), pos.mtag.getBid_amount(), pos.mtag.getBid_id(), pos.mtag.getTo_user_id(), (BaseActivity) context);
//                            }
//                        });
//                    } else {
//
//                        AppConstants.CARD_DET_BACK_SCREEN = context.getString(R.string.four);
//                        ((BaseActivity) context).nextScreen(AddPayCard.class, false);
//                    }
//                }
            }
        });

        viewHolder.mRejectBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final TagClass pos = (TagClass) v.getTag();

                DialogManager.showBaseTwoBtnDialog(context, context.getString(R.string.app_name), context.getString(R.string.rej_item), context.getString(R.string.yes), context.getString(R.string.no), new DialogManagerTwoBtnCallback() {
                    @Override
                    public void onBtnOkClick(String mOkStr) {
                        APIRequestHandler.getInstance().getOfferRejectResponse(pos.mtag.getBid_id(),(BaseActivity) context);
                    }

                    @Override
                    public void onBtnCancelClick(String mCancelStr) {

                    }
                });

            }
        });


        viewHolder.mNegtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final TagClass pos = (TagClass) v.getTag();
//                DialogManager.showBaseTwoBtnDialog(context,context. getString(R
//                        .string.app_name), context.getString(R.string.do_you_neg),context.
//                        getString(R
//                                .string
//                                .yes), context.getString(R.string.no), new DialogManagerTwoBtnCallback() {
//                    @Override
//                    public void onBtnOkClick(String mOkStr) {
//                    }
//
//                    @Override
//                    public void onBtnCancelClick(String mCancelStr) {
//
//                    }
//                });
//                DialogManager.showNegAlertDialog(context, context.getString(R.string.app_name), new DialogMangerOkCallback() {
//                    @Override
//                    public void onOkClick() {
////                        APIRequestHandler.getInstance().getOfferRejectResponse(pos.mtag.getBid_id(),(BaseActivity) context);
//                    }
//                });

                DialogManager.showBaseTwoBtnDialog(context,context. getString(R
                        .string.app_name), context.getString(R.string.do_you_neg),context.
                        getString(R
                        .string
                        .yes), context.getString(R.string.no), new DialogManagerTwoBtnCallback() {
                    @Override
                    public void onBtnOkClick(String mOkStr) {
                        pos.mtag.setBuyer_id(pos.mtag.getTo_user_id());
                        NegotiationChatRoom.mHomeSingleItemEntity = pos.mtag;
                        NegotiationChatRoom.mHomeSingleItemEntity.setBuyer_id(pos.mtag.getTo_user_id());

                        AppConstants.NEGO_FRIEND_ID = pos.mtag.getUser_id();
                        AppConstants.NEGO_BID_ID = pos.mtag.getBid_id();
                        AppConstants.NEGO_USER_ID = pos.mtag.getTo_user_id();
                        AppConstants.NEGO_ITEM_ID = pos.mtag.getItem_id();
                        AppConstants.NEGO_ITEM_QTY = pos.mtag.getQuantity();
                        AppConstants.CHAT_BACK = AppConstants.HOME_SCREEN;
                        AppConstants.NEGO_ITEM_NOTI = "";

//                            if (mHomeSingleItemEntity.getPayment_mode().equalsIgnoreCase(getString(R.string.three)) || GlobalMethods.getStringValue(ProductBuyNegScreen.this, AppConstants.CARD_DETAILS).equalsIgnoreCase(getString(R.string.one))) {


                        ((BaseActivity) context). nextScreen(NegotiationChatRoom.class, true);

                    }

                    @Override
                    public void onBtnCancelClick(String mCancelStr) {

                    }
                });
//                DialogManager.showNegAlertDialog(context, context.getString(R.string.nego), new DialogMangerOkCallback() {
//                    @Override
//                    public void onOkClick() {
//
//                        pos.mtag.setBuyer_id(pos.mtag.getTo_user_id());
//                        NegotiationChatRoom.mHomeSingleItemEntity = pos.mtag;
//                        NegotiationChatRoom.mHomeSingleItemEntity.setBuyer_id(pos.mtag.getTo_user_id());
//
//                        AppConstants.NEGO_FRIEND_ID = pos.mtag.getUser_id();
//                        AppConstants.NEGO_BID_ID = pos.mtag.getBid_id();
//                        AppConstants.NEGO_USER_ID = pos.mtag.getTo_user_id();
//                        AppConstants.NEGO_ITEM_ID = pos.mtag.getItem_id();
//                        AppConstants.NEGO_ITEM_QTY = pos.mtag.getQuantity();
//                        AppConstants.CHAT_BACK = AppConstants.HOME_SCREEN;
//                        AppConstants.NEGO_ITEM_NOTI = "";
//
////                            if (mHomeSingleItemEntity.getPayment_mode().equalsIgnoreCase(getString(R.string.three)) || GlobalMethods.getStringValue(ProductBuyNegScreen.this, AppConstants.CARD_DETAILS).equalsIgnoreCase(getString(R.string.one))) {
//
//
//                        ((BaseActivity) context). nextScreen(NegotiationChatRoom.class, true);
//
////                            } else {
////                                AppConstants.CARD_DET_BACK_SCREEN = getString(R.string.one);
////                                nextScreen(AddPayCard.class, false);
////                            }
//                    }
//                });
            }
        });

        viewHolder.mNameTxt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                TagClass pos = (TagClass) v.getTag();

                OtherUserProfile.mOtherUSerID = pos.mtag.getUser_id();
                ((BaseActivity) context).nextScreen(OtherUserProfile.class, false);

            }
        });
        viewHolder.mRating_bar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                TagClass pos = (TagClass) v.getTag();
                ReviewScreen.mOtherUserId = pos.mtag.getUser_id();
                ((BaseActivity) context).nextScreen(ReviewScreen.class, false);

            }
        });


        return convertView;
    }

    class TagClass {
        private HomeSingleItemEntity mtag;
    }

    class Holder {
        Button mAccBtn, mRejectBtn, mNegtn;
        TextView mNameTxt, mProductPriceTxt, mDateTxt;
        ImageView mProductImg;
        RatingBar mRating_bar;

        public Holder(View view) {
            mNameTxt = (TextView) view.findViewById(R.id.name_txt);
            mProductPriceTxt = (TextView) view.findViewById(R.id.product_price);
            mDateTxt = (TextView) view.findViewById(R.id.date_txt);
            mProductImg = (ImageView) view.findViewById(R.id.product_img);
            mRating_bar = (RatingBar) view.findViewById(R.id.user_ratingbar);

            mAccBtn = (Button) view.findViewById(R.id.acc_btn);
            mRejectBtn = (Button) view.findViewById(R.id.reject_btn);
            mNegtn = (Button) view.findViewById(R.id.neg_btn);

            mNameTxt.setTypeface(mLightFont);
            mProductPriceTxt.setTypeface(mRegulartFont);
            mDateTxt.setTypeface(mLightFont);
            mAccBtn.setTypeface(mLightFont);
            mRejectBtn.setTypeface(mLightFont);
            mNegtn.setTypeface(mLightFont);
        }
    }


}
