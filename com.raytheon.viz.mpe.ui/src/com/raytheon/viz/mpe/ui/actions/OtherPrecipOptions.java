/**
 * This software was developed and / or modified by Raytheon Company,
 * pursuant to Contract DG133W-05-CQ-1067 with the US Government.
 * 
 * U.S. EXPORT CONTROLLED TECHNICAL DATA
 * This software product contains export-restricted data whose
 * export/transfer/disclosure is restricted by U.S. law. Dissemination
 * to non-U.S. persons whether in the United States or abroad requires
 * an export license or other authorization.
 * 
 * Contractor Name:        Raytheon Company
 * Contractor Address:     6825 Pine Street, Suite 340
 *                         Mail Stop B8
 *                         Omaha, NE 68106
 *                         402.291.0100
 * 
 * See the AWIPS II Master Rights File ("Master Rights File.pdf") for
 * further licensing information.
 **/
package com.raytheon.viz.mpe.ui.actions;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import org.eclipse.swt.widgets.Button;

import com.raytheon.uf.common.ohd.AppsDefaults;
import com.raytheon.viz.mpe.ui.MPEDisplayManager;
import com.raytheon.viz.mpe.ui.dialogs.QcFreezeOptionsDialog;
import com.raytheon.viz.mpe.ui.dialogs.QcPrecipOptionsDialog;
import com.raytheon.viz.mpe.ui.dialogs.QcTempOptionsDialog;
import com.raytheon.viz.mpe.util.BadTValues;
import com.raytheon.viz.mpe.util.BadValues;
import com.raytheon.viz.mpe.util.CheckConsistency;
import com.raytheon.viz.mpe.util.CreateMap;
import com.raytheon.viz.mpe.util.DailyQcUtils;
import com.raytheon.viz.mpe.util.EstDailyStations;
import com.raytheon.viz.mpe.util.EstDailyTStations;
import com.raytheon.viz.mpe.util.EstMissingStations;
import com.raytheon.viz.mpe.util.EstMissingTStations;
import com.raytheon.viz.mpe.util.EstPartStations;
import com.raytheon.viz.mpe.util.MakeMat;
import com.raytheon.viz.mpe.util.MakeRsel;
import com.raytheon.viz.mpe.util.QCStations;
import com.raytheon.viz.mpe.util.QCTStations;
import com.raytheon.viz.mpe.util.ReadFreezingStationList;
import com.raytheon.viz.mpe.util.ReadTemperatureStationList;
import com.raytheon.viz.mpe.util.RenderPcp;
import com.raytheon.viz.mpe.util.RenderT;
import com.raytheon.viz.mpe.util.RenderT6;
import com.raytheon.viz.mpe.util.RenderZ;
import com.raytheon.viz.mpe.util.WriteQPFGrids;

/**
 * TODO Add Description
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Mar 30, 2009            snaples     Initial creation
 * 
 * </pre>
 * 
 * @author snaples
 * @version 1.0
 */

public class OtherPrecipOptions {
    
    private DailyQcUtils dqc = DailyQcUtils.getInstance();

    private static final int DEFAULT_ENDING_6HOUR_OBS_TIME = 6;

    public static int dcmode = 2;

    public static int tcmode = 2;

    public static int rsmode = 1;

    public static int change_pcpn_flag;

    public static int change_rpcpn_flag;

    public static int change_topo_flag;

    public static int change_frz_flag;

    public static int change_maxmin_flag;

    int isom;

    int MAX_GAGEQC_DAYS = 10;

    int time_pos;

    public void change_rsmode(int j) {

        rsmode = j;

        change_pcpn_flag = -1;
        change_rpcpn_flag = -1;

        if (rsmode == 0) {
            change_rpcpn_flag = 1;
        } else {
            change_pcpn_flag = 1;
        }
        send_expose();
        return;
    }

    public void change_TCmode(int j) {
        tcmode = j;
        refresh_exposure();
    }

    public void change_DCmode(int j) {
        dcmode = j;
        refresh_exposure();
    }

    public void chg_precip_time(int data) {

        int i = 0;
        int points_flag = dqc.points_flag;
        int grids_flag = dqc.grids_flag;
        int map_flag = dqc.map_flag;

        /* 24 hour or 6 hour time step */

        if (MPEDisplayManager.pcpn_time_step == 0) {
            time_pos = dqc.pcpn_time;
        } else {
            time_pos = 4;
        }

        if (data == 2 && MPEDisplayManager.pcpn_time_step == 0) {
            return;
        } else if (data == 2 && MPEDisplayManager.pcpn_time_step == 1) {
            MPEDisplayManager.pcpn_time_step = 0;
            dqc.pcp_flag = 3;
        } else if (data == 3 && MPEDisplayManager.pcpn_time_step == 1) {
            return;
        } else if (data == 3 && MPEDisplayManager.pcpn_time_step == 0) {
            MPEDisplayManager.pcpn_time_step = 1;

            if (dqc.curHr18_00 == 1 || dqc.curHr00_06 == 1
                    || dqc.curHr06_12 == 1) {
                dqc.pcp_flag = 0;
            }

            if (rsmode == 0) {

                change_rpcpn_flag = -1;
                change_pcpn_flag = 1;
                rsmode = 1;
                // show legend

            }

        }

        /* backward or forward */
        if (data == 0) {
            /* 6 hour precip time step mode. */
            if (MPEDisplayManager.pcpn_time_step == 0) {
                dqc.pcp_flag--;
            } else {
                /* 24 hour precip time step mode. */
                dqc.pcp_flag = dqc.pcp_flag - 4;
            }

        } else if (data == 1) {
            /* 6 hour precip time step mode. */
            if (MPEDisplayManager.pcpn_time_step == 0) {
                dqc.pcp_flag++;
            } else {
                /* 24 hour precip time step mode. */
                dqc.pcp_flag = dqc.pcp_flag + 4;
            }
        }

        if (dqc.pcp_flag < 0) {
            dqc.pcp_flag = 0;
        }

        if (dqc.pcp_flag >= (MAX_GAGEQC_DAYS * 4)) {
            dqc.pcp_flag = ((MAX_GAGEQC_DAYS * 4) - 1);
        }

        dqc.pcpn_day = dqc.pcp_flag / 4;

        dqc.pcpn_time = 3 - (dqc.pcp_flag - dqc.pcpn_day * 4);

        if (MPEDisplayManager.pcpn_time_step == 0) {
            time_pos = dqc.pcp_flag;
        } else {
            time_pos = 40 + dqc.pcpn_day;
        }

        QcPrecipOptionsDialog.dataSet.clear();
        QcPrecipOptionsDialog.dataSet.addAll(QcPrecipOptionsDialog.dataType);
        String[] a = new String[QcPrecipOptionsDialog.dataSet.size()];
        QcPrecipOptionsDialog.setDataSetCombo(QcPrecipOptionsDialog.dataSet
                .toArray(a));

        if (dqc.pcp_in_use[time_pos] == -1) {
            QcPrecipOptionsDialog.dataSet.clear();
            QcPrecipOptionsDialog.dataSet.add(0,
                    QcPrecipOptionsDialog.dataType.get(0));
            QcPrecipOptionsDialog.dataSet.add(1,
                    QcPrecipOptionsDialog.dataType.get(7));
            a = new String[QcPrecipOptionsDialog.dataSet.size()];
            QcPrecipOptionsDialog.setDataSetCombo(QcPrecipOptionsDialog.dataSet
                    .toArray(a));
        }

        if (points_flag == 1 && dqc.pcp_in_use[time_pos] == -1) {
            i = 0;
        } else if (points_flag == 1 && grids_flag == -1 && map_flag == -1) {
            i = 0;
        } else if (points_flag == -1 && grids_flag == 1 && map_flag == -1) {
            i = 1;
        } else if (points_flag == -1 && grids_flag == -1 && map_flag == 1) {
            i = 2;
        } else if (points_flag == 1 && grids_flag == 1 && map_flag == -1) {
            i = 3;
        } else if (points_flag == 1 && grids_flag == -1 && map_flag == 1) {
            i = 4;
        } else if (points_flag == -1 && grids_flag == -1 && map_flag == -1) {
            i = 5;
        }

        QcPrecipOptionsDialog.selectDataSetVal(i);

        if (dqc.pdata[dqc.pcpn_day].stddev == 5.0) {
            i = 0;
        } else if (dqc.pdata[dqc.pcpn_day].stddev == 3.0) {
            i = 1;
        } else {
            i = 2;
        }

        QcPrecipOptionsDialog.pntScnCbo.select(i);

        if ((dqc.pcp_in_use[time_pos] == -1)
                && ((((MPEDisplayManager.pcpn_time_step == 1) && (dqc.pdata[dqc.pcpn_day].used[4] != 0))) || ((MPEDisplayManager.pcpn_time_step == 0) && (dqc.pdata[dqc.pcpn_day].used[dqc.pcpn_time] != 0)))) {
            QcPrecipOptionsDialog.renderGridsBtn.setEnabled(true);
        } else {
            QcPrecipOptionsDialog.renderGridsBtn.setEnabled(false);
        }

        time_pos = 100 + dqc.pcp_flag;

        if (MPEDisplayManager.pcpn_time_step == 1) {

            for (i = 0; i < 1; i++) {
                QcPrecipOptionsDialog.pcpTypeCbo.setEnabled(false);
            }
            QcPrecipOptionsDialog.pcpTypeCbo.select(1);
        } else {

            if ((dqc.pcp_flag != 0 && (dqc.pcp_in_use[time_pos] == 1 || dqc.pcp_in_use[time_pos - 1] == 1))
                    || (dqc.pcp_flag == 0 && dqc.pcp_in_use[time_pos] != -1)) {

                for (i = 0; i < 1; i++) {
                    QcPrecipOptionsDialog.pcpTypeCbo.setEnabled(true);
                }

                QcPrecipOptionsDialog.pcpTypeCbo.select(rsmode);

            }

            else {

                for (i = 0; i < 1; i++) {
                    QcPrecipOptionsDialog.pcpTypeCbo.setEnabled(false);
                }

                QcPrecipOptionsDialog.pcpTypeCbo.select(1);
            }

        }

        Calendar tget = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
        long offset = (dqc.pcpn_day * 86400);
        tget.setTime(dqc.btime.getTime());
        tget.add(Calendar.SECOND, (int) -offset);
        dqc.isom = tget.get(Calendar.MONTH);

        /*
         * Set the sensitivity of the precipitation time step arrows based on
         * the current selected time.
         */
        set_precip_arrow_sensitivity();
        send_expose();
    }

    public void set_precip_arrow_sensitivity() {

        int num_qc_days = dqc.qcDays;
        int pcp_flag = dqc.pcp_flag;
        Button up_arrow = QcPrecipOptionsDialog.upTimeBtn;
        Button down_arrow = QcPrecipOptionsDialog.dnTimeBtn;

        /* 6 or 24 hour mode? */
        if (MPEDisplayManager.pcpn_time_step == 0) {
            /* 6 hour mode. */
            if (pcp_flag + 1 >= num_qc_days * 4) {
                /* Grey out the down arrow. */
                down_arrow.setEnabled(false);
            } else {
                /* Make sure that the down arrow is available. */
                down_arrow.setEnabled(true);
            }
            if (dqc.curHr18_00 == 1) {

                if (pcp_flag - 3 < 0) {
                    /* Grey out the up arrow. */
                    up_arrow.setEnabled(false);
                } else {
                    /* Make sure the up arrow is available. */
                    up_arrow.setEnabled(true);
                }
            } else if (dqc.curHr00_06 == 1) {
                if (pcp_flag - 2 <= 0) {
                    /* Grey out the up arrow. */
                    up_arrow.setEnabled(false);
                } else {
                    /* Make sure the up arrow is available. */
                    up_arrow.setEnabled(true);
                }
            } else if (dqc.curHr06_12 == 1) {
                if (pcp_flag - 1 <= 0) {
                    /* Grey out the up arrow. */
                    up_arrow.setEnabled(false);
                } else {
                    /* Make sure the up arrow is available. */
                    up_arrow.setEnabled(true);
                }
            } else {
                if (pcp_flag - 1 < 0) {
                    /* Grey out the up arrow. */
                    up_arrow.setEnabled(false);
                } else {
                    /* Make sure the up arrow is available. */
                    up_arrow.setEnabled(true);
                }
            }
            Calendar currentTime = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
            Calendar tmpDate = (Calendar) currentTime.clone();
            tmpDate.setTime(dqc.pdata[dqc.pcpn_day].data_time);
            tmpDate.add(Calendar.HOUR_OF_DAY, (dqc.pcpn_time-3)*6);

            if (currentTime.before(tmpDate)){
            	up_arrow.setEnabled(false);
            }
        } else {
            /* 24 hour mode. */
            if (pcp_flag + 4 >= num_qc_days * 4) {
                /* Grey out the down arrow. */
                down_arrow.setEnabled(false);
            } else {
                /* Make sure that the down arrow is available. */
                down_arrow.setEnabled(true);
            }
            /* determine the up arrow status */

            if (dqc.curHr18_00 == 1 || dqc.curHr00_06 == 1
                    || dqc.curHr06_12 == 1) {
                if (pcp_flag - 7 <= 0) {
                    up_arrow.setEnabled(false);
                } else {
                    up_arrow.setEnabled(true);
                }

            } else {
                if (pcp_flag - 4 < 0) {
                    /* Grey out the up arrow. */
                    up_arrow.setEnabled(false);
                } else {
                    up_arrow.setEnabled(true);
                }
            }
        }
    }

    public void display_pcpn_options(int data) {
        /* Initialize the display flags. */
        dqc.points_flag = -1;
        dqc.grids_flag = -1;
        dqc.map_flag = -1;
        dqc.contour_flag = -1;

        if (data == 0) {
            dqc.points_flag = 1;
        }

        else if (data == 1) {
            dqc.grids_flag = 1;
        } else if (data == 2) {
            dqc.map_flag = 1;
        } else if (data == 3) {
            dqc.points_flag = 1;
            dqc.grids_flag = 1;
        } else if (data == 4) {
            dqc.points_flag = 1;
            dqc.map_flag = 1;
        } else if (data == 5) {
            dqc.points_flag = -1;
            dqc.contour_flag = 1;
        } else if (data == 6) {
            dqc.points_flag = 1;
            dqc.contour_flag = 1;
        } else if (data == 7) {
            dqc.contour_flag = -1;
            dqc.points_flag = -1;
            dqc.grids_flag = -1;
            dqc.map_flag = -1;
        }
        send_expose();
    }

    public void render_options(int i) {
        AppsDefaults appsDefaults = AppsDefaults.getInstance();
        final String dqc_ending_6hour_obstime_tok = "dqc_ending_6hour_obstime";
        int dqcTimeStringIndex = 0;
        int k = 0;
        int clientdata = i;
        Date old_time = null;
        String dbuf = "";
//        String[][] timefile = dqc.timefile;
//        String[][] ztimefile = dqc.ztimefile;
//        String[][] ttimefile = dqc.ttimefile;
        WriteQPFGrids wq = new WriteQPFGrids();
        RenderPcp rpc = new RenderPcp();
        CreateMap cm = new CreateMap();
        MakeRsel mr = new MakeRsel();
//        Hrap_Grid hrap_grid = DailyQcUtils.getHrap_grid();
        Calendar tmtime = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
//        ReadPrecipStationList rp = new ReadPrecipStationList();
        int num_stations = dqc.precip_stations.size();
        String s = appsDefaults.getToken(dqc_ending_6hour_obstime_tok);
        int dqc_ending_6hour_obstime = ((!(null == s)) ? Integer.parseInt(s)
                : -1);

        if (dqc_ending_6hour_obstime == -1) {
            dqc_ending_6hour_obstime = DEFAULT_ENDING_6HOUR_OBS_TIME;
        }
        dqcTimeStringIndex = (dqc_ending_6hour_obstime / 6) + 1;
        // if (DailyQcUtils.mpe_td_details_set == 1) {
        // // do nothing
        // }

        if (clientdata == 1) {
            // do nothing
        }

        /* Rendering the grids and MAPs. */
        else if (clientdata == 0) {

            BadValues bv = new BadValues();
            bv.update_bad_values(dqc.pcpn_day);

            /*
             * do not estimate daily and partial point precipitation from each
             * other if run DQC on partial time frame and pcpn_day=0
             */
            if (dqc.pcpn_day == 0
                    && (dqc.curHr00_06 == 1
                            || dqc.curHr06_12 == 1 || dqc.curHr18_00 == 1)) {
                // don't estimate
            } else {

                EstDailyStations ed = new EstDailyStations();
                ed.estimate_daily_stations(dqc.pcpn_day,
                        dqc.precip_stations, num_stations);

                EstPartStations ep = new EstPartStations();
                ep.estimate_partial_stations(dqc.pcpn_day,
                        dqc.precip_stations, num_stations);
            }

            QCStations qs = new QCStations();
            qs.quality_control_stations(dqc.pcpn_day,
                    dqc.precip_stations, num_stations);

            CheckConsistency cc = new CheckConsistency();
            cc.check_consistency(dqc.pcpn_day,
                    dqc.precip_stations, num_stations);

            /* render Grids and MAP for 24 hr precipitation */

            /*
             * if run DQC at the time frames such as curHr18_00 or curHr00_06 or
             * curHr06_12, for precipitation, do not display the 24 hr
             * precipiation if the pcpn_day=0
             */
            if ((dqc.pcpn_day == 0)
                    && (dqc.curHr18_00 == 1
                            || dqc.curHr00_06 == 1 || dqc.curHr06_12 == 1)) {
                dqc.pdata[dqc.pcpn_day].used[4] = 0;
            }

            if (dqc.pdata[dqc.pcpn_day].used[4] != 0) {

                rpc.render_pcp(dqc.pcpn_day, dqc.pcpn_time,
                        1, num_stations, dqc.precip_stations,
                        dqc.getHrap_grid(), dqc.pdata, dqc.pcp_in_use);

                old_time = dqc.pdata[dqc.pcpn_day].data_time;
                tmtime.setTime(old_time);

                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.grid_file, dqc.timefile[2][4],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                /* output grid to file in netCDF format */
                // TODO output grid to file in netCDF format
                // if( mpe_dqc_save_netcdf == 1)
                // {
                // if (pcpn_time < 4)
                // begin_time = pdata[pcpn_day].data_time - (4 - pcpn_time) *
                // 21600L;
                // else
                // begin_time = pdata[pcpn_day].data_time - 86400L;
                //
                // write_dqc_netcdf_grids(dbuf, pdata[pcpn_day].data_time,
                // &begin_time, 1);
                // }
                cm.create_map(40 + dqc.pcpn_day);
            }

            /* render Grids and MAP for four 6hr precipitation */
            /*
             * m=0 represents the time frame 12 - 18, m=1 represents time frame
             * 18-00, m=2 represents time frame 00-06Z
             */

            if (dqc.pcpn_day == 0 && dqc.curHr18_00 == 1) {
                dqc.pdata[dqc.pcpn_day].used[1] = 0;
                dqc.pdata[dqc.pcpn_day].used[2] = 0;
                dqc.pdata[dqc.pcpn_day].used[3] = 0;
            } else if (dqc.pcpn_day == 0
                    && dqc.curHr00_06 == 1) {
                dqc.pdata[dqc.pcpn_day].used[2] = 0;
                dqc.pdata[dqc.pcpn_day].used[3] = 0;
            } else if (dqc.pcpn_day == 0
                    && dqc.curHr06_12 == 1) {
                dqc.pdata[dqc.pcpn_day].used[3] = 0;
            }

            for (int m = 0; m < 4; m++) {

                if (dqc.pdata[dqc.pcpn_day].used[m] == 0) {
                    continue;
                }

                rpc.render_pcp(dqc.pcpn_day, m, 0, num_stations,
                        dqc.precip_stations, dqc.getHrap_grid(),
                        dqc.pdata, dqc.pcp_in_use);

                if (m < 2) {
                    old_time = dqc.pdata[dqc.pcpn_day].data_time;
                    tmtime.setTime(old_time);
                    tmtime.add(Calendar.SECOND, -86400);
                } else {
                    old_time = dqc.pdata[dqc.pcpn_day].data_time;
                    tmtime.setTime(old_time);
                }

                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.grid_file, dqc.timefile[2][m],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                /* output grid to file in netCDF format */
                // TODO output grid to file in netCDF format
                // if( mpe_dqc_save_netcdf == 1)
                // {
                // if (m < 4)
                // begin_time = pdata[pcpn_day].data_time - (4 - m) * 21600L;
                // else
                // begin_time = pdata[pcpn_day].data_time - 86400L;
                //
                // write_dqc_netcdf_grids(dbuf, pdata[pcpn_day].data_time,
                // &begin_time, 1);
                // }
                int num = 4 * dqc.pcpn_day + 3 - m;

                cm.create_map(num);

                dqc.pdata[dqc.pcpn_day].used[m] = 3;

            }

            EstMissingStations ems = new EstMissingStations();
            ems.estimate_missing_stations(dqc.pcpn_day,
                    dqc.precip_stations, num_stations,
                    dqc.pdata);

            bv.restore_bad_values(dqc.pcpn_day,
                    dqc.precip_stations, num_stations);

            if ((dqc.pcpn_day == 0)
                    && (dqc.curHr18_00 == 1
                            || dqc.curHr00_06 == 1 || dqc.curHr06_12 == 1)) {
                dqc.pdata[dqc.pcpn_day].used[4] = 0;
            } else {
                dqc.pdata[dqc.pcpn_day].used[4] = 3;
            }

            QcPrecipOptionsDialog.dataSet.clear();
            QcPrecipOptionsDialog.dataSet
                    .addAll(QcPrecipOptionsDialog.dataType);
            String[] a = new String[QcPrecipOptionsDialog.dataSet.size()];
            QcPrecipOptionsDialog.setDataSetCombo(QcPrecipOptionsDialog.dataSet
                    .toArray(a));

            if (MPEDisplayManager.pcpn_time_step == 0) {
                time_pos = dqc.pcp_flag;
            } else {
                time_pos = 40 + dqc.pcpn_day;
            }

            if (dqc.points_flag == 1
                    && dqc.pcp_in_use[time_pos] == -1) {
                k = 0;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                // Points
                k = 0;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                // Grids
                k = 1;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                // MATs
                k = 2;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                // Points & Grids
                k = 3;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                // Points & MATs
                k = 4;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1) {
                // Contours
                k = 5;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == 1) {
                // Points & Contours
                k = 6;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                // None
                k = 7;
            }

            QcPrecipOptionsDialog.selectDataSetVal(k);

        } else if (clientdata == 2) {
            int m;
            int num_zstations;
            ReadFreezingStationList rfl = new ReadFreezingStationList();
            num_zstations = rfl.getNumZstations();
            RenderZ rz = new RenderZ();

            // logMessage ("Gridding freezing level and building MAZs" );

            /* render Grids and MAZ for four 6hr precipitation */
            /*
             * m=0 represents the time frame 12 - 18, m=1 represents time frame
             * 18-00, m=2 represents time frame 00-06Z
             */

            if (dqc.pcpn_day == 0 && dqc.curHr18_00 == 1) {
                dqc.zdata[dqc.pcpn_day].used[1] = 0;
                dqc.zdata[dqc.pcpn_day].used[2] = 0;
                dqc.zdata[dqc.pcpn_day].used[3] = 0;
            } else if (dqc.pcpn_day == 0
                    && dqc.curHr00_06 == 1) {
                dqc.zdata[dqc.pcpn_day].used[2] = 0;
                dqc.zdata[dqc.pcpn_day].used[3] = 0;
            } else if (dqc.pcpn_day == 0
                    && dqc.curHr06_12 == 1) {
                dqc.zdata[dqc.pcpn_day].used[3] = 0;
            }

            for (m = 0; m < 4; m++) {

                if (dqc.zdata[dqc.pcpn_day].used[m] == 0
                        || dqc.zdata[dqc.pcpn_day].used[m] == 3
                        || (dqc.zdata[dqc.pcpn_day].used[m] == 1 && dqc.zdata[dqc.pcpn_day].level[m] == 2)
                        || dqc.zdata[dqc.pcpn_day].used[m] == 4) {
                    /*
                     * logMessage(
                     * "\n in other pcpn zdata used = %d pcpn_dauy=%d m=%d\n"
                     * ,zdata[pcpn_day].used[m],pcpn_day, m);
                     */
                    continue;
                }

                rz.render_z(dqc.pcpn_day, m, 0, num_zstations,
                        dqc.freezing_stations, dqc.getHrap_grid(),
                        dqc.zdata, dqc.pcp_in_use);
                /*
                 * dqcEndingObsTime is controlled by the
                 * dqc_ending_6hour_obstime token. It should only be 06 or 12
                 * and the default is 06. However, have to account for it being
                 * set to 12 and original code didn't account for this.
                 */
                if (dqc.dqc_ending_6hour_obstime == 12) {

                    if (m < 1) {
                        old_time = dqc.zdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                        tmtime.add(Calendar.SECOND, -86400);
                    } else {
                        old_time = dqc.zdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                    }
                } else {
                    if (m < 2) {
                        old_time = dqc.zdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                        tmtime.add(Calendar.SECOND, -86400);
                    } else {
                        old_time = dqc.zdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                    }
                }
                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.zgrid_file,
                        dqc.ztimefile[dqcTimeStringIndex][m],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                int num = 100 + 4 * dqc.pcpn_day + 3 - m;

                dqc.zdata[dqc.pcpn_day].used[m] = 3;

                mr.make_rsel(num, num - 100);
                /*
                 * logMessage(
                 * "\n other pcpn end of loop zdata use = %d pcpn_day=%d m=%d\n"
                 * ,zdata[pcpn_day].used[m], pcpn_day, m);
                 */
            }

            QcFreezeOptionsDialog.dataSet.clear();
            QcFreezeOptionsDialog.dataSet
                    .addAll(QcFreezeOptionsDialog.dataType);
            String[] a = new String[QcFreezeOptionsDialog.dataSet.size()];
            QcFreezeOptionsDialog.dataDispCbo
                    .setItems(QcFreezeOptionsDialog.dataSet.toArray(a));

            time_pos = 100 + dqc.pcp_flag;

            if (dqc.points_flag == 1
                    && dqc.pcp_in_use[time_pos] == -1) {
                k = 0;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                // Points
                k = 0;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                // Grids
                k = 1;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                // MATs
                k = 2;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                // Points & Grids
                k = 3;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                // Points & MATs
                k = 4;
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == 1) {
                // Contours
                k = 5;
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == 1) {
                // Points & Contours
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                // None
                k = 7;
            }
            QcFreezeOptionsDialog.dataDispCbo.select(k);

        } else if (clientdata == 3) {

            // logMessage ("Gridding temperature and building MATs");

            ReadTemperatureStationList rt = new ReadTemperatureStationList();
            int num_tstations = rt.getNumTstations();
            BadTValues bt = new BadTValues();
            bt.update_bad_tvalues(dqc.pcpn_day);

            /*
             * do not estimate daily and partial point precipitation from each
             * other if run DQC on partial time frame and pcpn_day=0
             */

            if (dqc.pcpn_day == 0
                    && (dqc.curHr00_06 == 1
                            || dqc.curHr06_12 == 1 || dqc.curHr18_00 == 1)) {
                // do not run estimate on stations
            } else {
                EstDailyTStations edt = new EstDailyTStations();
                edt.estimate_daily_tstations(dqc.pcpn_day,
                        dqc.temperature_stations, num_tstations);
            }
            QCTStations qct = new QCTStations();
            qct.quality_control_tstations(dqc.pcpn_day,
                    dqc.temperature_stations, num_tstations);

            if (dqc.pcpn_day == 0 && dqc.curHr18_00 == 1) {
                dqc.tdata[dqc.pcpn_day].used[1] = 0;
                dqc.tdata[dqc.pcpn_day].used[2] = 0;
                dqc.tdata[dqc.pcpn_day].used[3] = 0;

            } else if (dqc.pcpn_day == 0
                    && dqc.curHr00_06 == 1) {
                dqc.tdata[dqc.pcpn_day].used[2] = 0;
                dqc.tdata[dqc.pcpn_day].used[3] = 0;

            } else if (dqc.pcpn_day == 0
                    && dqc.curHr06_12 == 1) {
                dqc.tdata[dqc.pcpn_day].used[3] = 0;

            }

            RenderT rent = new RenderT();
            if (dqc.tdata[dqc.pcpn_day].used[4] != 0) {

                rent.render_t(dqc.pcpn_day, dqc.pcpn_time, 1,
                        num_tstations, dqc.temperature_stations,
                        dqc.getHrap_grid(), dqc.tdata, dqc.pcp_in_use);

                old_time = dqc.tdata[dqc.pcpn_day].data_time;
                tmtime.setTime(old_time);

                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.tgrid_file,
                        dqc.ttimefile[dqcTimeStringIndex][4],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                dqc.tdata[dqc.pcpn_day].used[4] = 3;

            }

            if (dqc.tdata[dqc.pcpn_day].used[5] != 0) {

                rent.render_t(dqc.pcpn_day, dqc.pcpn_time, 2,
                        num_tstations, dqc.temperature_stations,
                        dqc.getHrap_grid(), dqc.tdata, dqc.pcp_in_use);

                old_time = dqc.tdata[dqc.pcpn_day].data_time;

                tmtime.setTime(old_time);

                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.tgrid_file,
                        dqc.ttimefile[dqcTimeStringIndex][5],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                dqc.tdata[dqc.pcpn_day].used[5] = 3;

            }

            for (int m = 0; m < 4; m++) {

                if (dqc.tdata[dqc.pcpn_day].used[m] == 0
                        || dqc.tdata[dqc.pcpn_day].used[m] == 3
                        || (dqc.tdata[dqc.pcpn_day].used[m] == 1 && dqc.tdata[dqc.pcpn_day].level[m] == 2)
                        || dqc.tdata[dqc.pcpn_day].used[m] == 4) {
                    continue;
                }

                RenderT6 rt6 = new RenderT6();
                rt6.render_t6(dqc.pcpn_day, m, 0, num_tstations,
                        dqc.temperature_stations, dqc.getHrap_grid(),
                        dqc.tdata, dqc.pcp_in_use);

                /*
                 * dqcEndingObsTime is controlled by the
                 * dqc_ending_6hour_obstime token. It should only be 06 or 12
                 * and the default is 06. However, have to account for it being
                 * set to 12 and original code didn't account for this.
                 */

                if (dqc_ending_6hour_obstime == 12) {

                    if (m < 1) {
                        old_time = dqc.tdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                        tmtime.add(Calendar.SECOND, -86400);
                    } else {
                        old_time = dqc.tdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                    }
                } else {
                    if (m < 2) {
                        old_time = dqc.tdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                        tmtime.add(Calendar.SECOND, -86400);
                    } else {
                        old_time = dqc.tdata[dqc.pcpn_day].data_time;
                        tmtime.setTime(old_time);
                    }
                }

                dbuf = String.format("%s%s_%04d%02d%02d",
                        dqc.tgrid_file,
                        dqc.ttimefile[dqcTimeStringIndex][m],
                        tmtime.get(Calendar.YEAR),
                        tmtime.get(Calendar.MONTH) + 1,
                        tmtime.get(Calendar.DAY_OF_MONTH));

                wq.write_qpf_grids(dbuf);

                int num = 150 + 4 * dqc.pcpn_day + 3 - m;

                dqc.tdata[dqc.pcpn_day].used[m] = 3;

                MakeMat mmat = new MakeMat();
                mmat.make_mat(num, num - 150);

                dqc.tdata[dqc.pcpn_day].used[m] = 3;

            }

            EstMissingTStations emt = new EstMissingTStations();
            emt.estimate_missing_tstations(dqc.pcpn_day,
                    dqc.temperature_stations, num_tstations,
                    dqc.tdata);

            BadTValues btv = new BadTValues();
            btv.restore_bad_tvalues(dqc.pcpn_day,
                    dqc.temperature_stations, num_tstations);

            QcTempOptionsDialog.dataSet.clear();
            QcTempOptionsDialog.dataSet.addAll(QcTempOptionsDialog.dataType);
            String[] a = new String[QcTempOptionsDialog.dataSet.size()];
            QcTempOptionsDialog.dataDispCbo
                    .setItems(QcTempOptionsDialog.dataSet.toArray(a));

            time_pos = 150 + dqc.pcp_flag;

            if (dqc.points_flag == 1
                    && dqc.pcp_in_use[time_pos] == -1) {
                k = 0; // Points
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                k = 0; // Points
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                k = 1; // Grids
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                k = 2; // MATs
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == 1
                    && dqc.map_flag == -1) {
                k = 3; // Points + Grids
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == 1) {
                k = 4; // Points + MATs
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == 1) {
                k = 5; // Contours
            } else if (dqc.points_flag == 1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == 1) {
                k = 6; // Points + Contours
            } else if (dqc.points_flag == -1
                    && dqc.grids_flag == -1
                    && dqc.map_flag == -1
                    && dqc.contour_flag == -1) {
                k = 7; // None
            }

            QcTempOptionsDialog.dataDispCbo.select(k);
        }

        if (MPEDisplayManager.getCurrent().isQpf() == true) {
            QcPrecipOptionsDialog.renderGridsBtn.setEnabled(false);
        } else if (MPEDisplayManager.getCurrent().isZflag() == true) {
            // QcFreezingOptionsDialog.renderGridsBtn.setEnabled(false);
        } else if (MPEDisplayManager.getCurrent().isMaxmin() == true) {
            QcTempOptionsDialog.renderGridsBtn.setEnabled(false);
        }
        send_expose();
        // refresh_exposure();
    }

    public void send_expose() {
        if (QcPrecipOptionsDialog.isOpen == true) {
            QcPrecipOptionsDialog.ddq.reloadDQC();
        } else if (QcTempOptionsDialog.isOpen == true) {
            QcTempOptionsDialog.ddq.reloadDQC();
        } else if (QcFreezeOptionsDialog.isOpen == true) {
            QcFreezeOptionsDialog.ddq.reloadDQC();
        }
    }

    public void refresh_exposure() {
        if (QcPrecipOptionsDialog.isOpen == true) {
            QcPrecipOptionsDialog.ddq.reexposeDQC();
        } else if (QcTempOptionsDialog.isOpen == true) {
            QcTempOptionsDialog.ddq.reexposeDQC();
        } else if (QcFreezeOptionsDialog.isOpen == true) {
            QcFreezeOptionsDialog.ddq.reexposeDQC();
        }
    }
}
