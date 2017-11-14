package com.bridgellc.bridge.adapter;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.bridgellc.bridge.R;
import com.bridgellc.bridge.entity.HomeSingleItemEntity;
import com.bridgellc.bridge.main.BaseActivity;
import com.bridgellc.bridge.ui.ProductDetailsScreen;
import com.bridgellc.bridge.ui.RequestBiddingScreen;
import com.bridgellc.bridge.utils.AppConstants;
import com.bridgellc.bridge.utils.DialogManager;
import com.bridgellc.bridge.utils.GlobalMethods;
import com.bridgellc.bridge.utils.ImageViewRounded;
import com.bridgellc.bridge.utils.TypefaceSingleton;
import com.bumptech.glide.Glide;

import java.util.ArrayList;


public class ProfileListAdapter extends BaseAdapter {
    private Context mContext;
    private Holder viewHolder;
    private String mTag;
    private Typeface mLightFont, mRegulartFont;
    private ArrayList<HomeSingleItemEntity> mProfileDataList;


    public ProfileListAdapter(Context context, ArrayList<HomeSingleItemEntity> mList, String tag) {
        this.mContext = context;
        this.mProfileDataList = mList;
        this.mTag = tag;

        this.mLightFont = TypefaceSingleton.getTypeface().getLightFont(context);
        this.mRegulartFont = TypefaceSingleton.getTypeface().getRegularFont(context);
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
//        viewHolder = new Holder(convertView);
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(R.layout.home_grid_item, parent, false);
            viewHolder = new Holder(convertView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (Holder) convertView.getTag();
        }

        if (mProfileDataList.get(position).getItem_mode().equalsIgnoreCase("1")) {
            viewHolder.mProductPriceTxt.setBackgroundResource(R.drawable.home_blue_small);
        } else {
            viewHolder.mProductPriceTxt.setBackgroundResource(R.drawable.home_green_small);
        }

        String productPriceText = "";
//        if (mProfileDataList.get(position).getItem_cost() != null) {
//            productPriceText = GlobalMethods.getPriValWithTwoPoint(mProfileDataList
//                    .get(position).getItem_cost());
//
//        }

        if (mTag.equalsIgnoreCase(mContext.getString(R.string.nw))) {
            productPriceText = GlobalMethods.getPriValWithTwoPoint(mProfileDataList
                    .get(position).getItem_cost(), false);
        } else if (mTag.equalsIgnoreCase(mContext.getString(R.string.negotiating))) {
            productPriceText = GlobalMethods.getPriValWithTwoPoint(mProfileDataList
                    .get(position).getNegotiate_cost(), false);
        } else {
            if (GlobalMethods.isSeller(mContext, mProfileDataList.get(position).getUser_id())) {
                productPriceText = GlobalMethods.getPriValWithTwoPoint(mProfileDataList
                        .get(position).getItem_cost(), false);
            } else {
                productPriceText = GlobalMethods.getPriValWithTwoPoint(mProfileDataList
                        .get(position).getAmount_received(), false);
            }
        }

        if (mTag.equalsIgnoreCase(mContext.getString(R.string.sale_to_com)) || mTag.equalsIgnoreCase(mContext.getString(R.string.buying_orders))) {
            if (mProfileDataList.get(position).getChat_count() != null && !mProfileDataList.get
                    (position)
                    .getChat_count().equalsIgnoreCase("") && !mProfileDataList.get
                    (position)
                    .getChat_count().equalsIgnoreCase(AppConstants.FAILURE_CODE)) {
                viewHolder.mChatsLableTxt.setVisibility(View.VISIBLE);
                viewHolder.mChatsLableTxt.setText(mProfileDataList.get(position).getChat_count());
                viewHolder.mChatsLableTxt.setTypeface(mLightFont);
            } else {
                viewHolder.mChatsLableTxt.setVisibility(View.GONE);
            }
        } else {

            viewHolder.mChatsLableTxt.setVisibility(View.GONE);
        }
//        if (mProfileDataList.get(position).getAmount_received() != null && mProfileDataList.get
//                (position).getAmount_received().length() > 0) {
////            int totalAmount = (int) (Double.parseDouble(mProfileDataList.get(position)
////                    .getAmount_received()) + Double.parseDouble(mProfileDataList.get(position)
////                    .getProcessing_fee()));
//            int totalAmount = (int) (Double.parseDouble(mProfileDataList.get(position)
//                    .getAmount_received()));
//
//
//            productPriceText = "$" + totalAmount;
//        }
        viewHolder.mProductPriceTxt.setText("$" + productPriceText);
        viewHolder.mProductPriceTxt.setTypeface(mRegulartFont);
        viewHolder.mProductName.setText(mProfileDataList.get(position).getItem_name());
        viewHolder.mProductName.setTypeface(mRegulartFont);

        TagClass tagClass = new TagClass();
        tagClass.mtag = mTag;
        tagClass.homeSingleItemEntity = mProfileDataList.get(position);
        viewHolder.mProductPriceTxt.setTag(tagClass);

        try {
            Glide.with(mContext)
                    .load(mProfileDataList.get(position).getPicture1())
                    .asBitmap().into(viewHolder.mImageViewRounded);
        } catch (Exception e) {
            viewHolder.mImageViewRounded.setImageResource(R.drawable.home_bubble_placeholder);
        }
        viewHolder.mHomeSingleItemEntity = mProfileDataList.get(position);


        viewHolder.mProductPriceTxt.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                TagClass tagClass1 = (TagClass) v.getTag();
                ProductDetailsScreen.mHomeSingleItemEntity = tagClass1.homeSingleItemEntity;
//                ProductDetailsScreen.priceAmount = "$" + String.format("%.02f", Double.parseDouble
//                        (ProductDetailsScreen.mHomeSingleItemEntity.getItem_cost()));


                if (tagClass1.mtag.equalsIgnoreCase(mContext.getString(R.string.nw)) || tagClass1
                        .mtag.equalsIgnoreCase(mContext.getString(R.string.negotiating)) ||
                        tagClass1.mtag.contains(mContext.getString(R.string.history))) {
                    sellNewNegHis(tagClass1.mtag, tagClass1.homeSingleItemEntity);
                } else if (tagClass1.mtag.equalsIgnoreCase(mContext.getString(R.string.sale_to_com))) {
                    sellBuyerApprovList(tagClass1.homeSingleItemEntity);
                } else if (tagClass1.mtag.equalsIgnoreCase(mContext.getString(R.string.buying_orders))) {
                    buyerOrderList(tagClass1.homeSingleItemEntity);
                } else if (tagClass1.mtag.equalsIgnoreCase(mContext.getString(R.string.bidding_orders))) {
                    if (tagClass1.homeSingleItemEntity.getNegotiate_offers() != null && tagClass1.homeSingleItemEntity.getNegotiate_offers().equalsIgnoreCase(mContext.getString(R.string.one))) {
                        ProductDetailsScreen.mFooterBtnCount = 1;
                        ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.negotiation);
                    } else {
                        ProductDetailsScreen.mFooterBtnCount = 0;
                    }
                }

                AppConstants.PRODUCT_DETAILS_BACK = mContext.getString(R.string.one);
                if (tagClass1.mtag.equalsIgnoreCase(mContext.getString(R.string.offers))) {
                    RequestBiddingScreen.mItemId = tagClass1.homeSingleItemEntity.getItem_id();
                    ((BaseActivity) mContext).nextScreen(RequestBiddingScreen.class, true);
                } else {
                    ((BaseActivity) mContext).nextScreen(ProductDetailsScreen.class, true);
                }
            }
        });


        viewHolder.mProductPriceTxt.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                TagClass tagClass1 = (TagClass) v.getTag();
                if (tagClass1.homeSingleItemEntity.getPicture1() != null) {
                    DialogManager.ImageViewer(mContext,
                            tagClass1.homeSingleItemEntity.getPicture1());

                }
                return true;
            }

        });

        return convertView;

    }


    private class TagClass {
        private String mtag;
        private HomeSingleItemEntity homeSingleItemEntity;
    }

    private class Holder {
        private TextView mProductPriceTxt, mProductName, mChatsLableTxt;
        private ImageViewRounded mImageViewRounded;
        private HomeSingleItemEntity mHomeSingleItemEntity;

        private Holder(View mView) {
            mProductPriceTxt = (TextView) mView.findViewById(R.id.product_price);

            mProductName = (TextView) mView.findViewById(R.id.product_name);
            mChatsLableTxt = (TextView) mView.findViewById(R.id.chats_lable);
            mImageViewRounded = (ImageViewRounded) mView.findViewById(R.id.product_img);

        }
    }

    @Override
    public int getCount() {
        return mProfileDataList.size();
    }

    @Override
    public Object getItem(int position) {
        return mProfileDataList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    private void sellNewNegHis(String post, HomeSingleItemEntity homeSingItemEntity) {

        ProductDetailsScreen.mFooterBtnCount = 1;

        if (post.equalsIgnoreCase(mContext.getString(R.string.nw))) {
            ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.edit);
        } else {
            if (post.equalsIgnoreCase(mContext.getString(R.string.negotiating)))
                ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.negotiation);
            else {
                ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.chat);
                ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.rating);
                ProductDetailsScreen.mFooterBtnCount = 2;
                if (homeSingItemEntity.getItem_type().equalsIgnoreCase(mContext.getString(R.string.one)) && homeSingItemEntity.getDelivery_type().equalsIgnoreCase(mContext.getString(R.string.two))) {
                    ProductDetailsScreen.mFooterBtnCount = 1;
                    ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.rating);
                }
            }
        }
    }

    private void sellBuyerApprovList(HomeSingleItemEntity homeSingleItemEntity) {

        ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.chat);
        ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.finish);
        ProductDetailsScreen.mFooterBtnCount = 2;

        if (homeSingleItemEntity.getItem_type().equalsIgnoreCase(mContext.getString(R.string.two))) {
            if (homeSingleItemEntity.getDelivery_type().equalsIgnoreCase(mContext.getString(R.string.one))) {

            } else {
                ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.upload_txt);
            }
        }
    }


    private void buyerOrderList(HomeSingleItemEntity buypost) {

        ProductDetailsScreen.mFooterOneTxt = mContext.getString(R.string.chat);
        ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.code);
        ProductDetailsScreen.mFooterThreeTxt = mContext.getString(R.string.unsatis);
        ProductDetailsScreen.mFooterBtnCount = 3;


        if (buypost.getItem_type().equalsIgnoreCase(mContext.getString(R.string.two))) {
            if (buypost.getDelivery_type().equalsIgnoreCase(mContext.getString(R.string.one))) {
                ProductDetailsScreen.mFooterBtnCount = 2;
                ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.start);

            } else {

                ProductDetailsScreen.mFooterTwoTxt = mContext.getString(R.string.preview);
                ProductDetailsScreen.mFooterThreeTxt = mContext.getString(R.string.approve);
            }
        }
    }
}




