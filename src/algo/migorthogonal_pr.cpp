//
// Created by marcel on 13.07.17.
// Modified 2021.05 by Julio
//

#include "migorthogonal_pr.h"
#include <iostream>
#include <stddef.h>

migorthogonal_pr::migorthogonal_pr(logic_network_ptr ln, const unsigned n, const bool io)
        :
        place_route(std::move(ln)),
        phases{n},
        io_ports{io}
{}

migorthogonal_pr::pr_result migorthogonal_pr::perform_place_and_route()
{
//JULIO
//    if (!network->is_AOIG())
//    {
//        std::cout << "[e] logic network has to be an AOIG" << std::endl;
//        return pr_result{false, nlohmann::json{{"runtime", calc_runtime(chrono::now(), chrono::now())}}};
//    }


    auto start = chrono::now();

    // get joint DFS ordering
    auto jDFS = jdfs_order();
    // compute a red-blue-coloring for the network
    auto rbColoring = find_rb_coloring(jDFS);

    try
    {
        // use the coloring for an migorthogonal embedding
        migorthogonal_embedding(rbColoring, jDFS);
    }
    catch (...)
    {
        return pr_result{false, nlohmann::json{{"runtime", calc_runtime(start, chrono::now())}}};
    }

    return pr_result{true, nlohmann::json{{"runtime", calc_runtime(start, chrono::now())}}};
}

migorthogonal_pr::jdfs_ordering migorthogonal_pr::jdfs_order() const
{
    // stores the ordering
    jdfs_ordering ordering{};
    // store discovery of nodes
    std::unordered_map<logic_network::vertex, bool> discovered{};
    // range of logic vertices
    auto vertices = network->vertices(io_ports);
    // initialize all vertices undiscovered
    std::for_each(vertices.begin(), vertices.end(),
                  [&discovered](const logic_network::vertex _v){discovered.emplace(_v, false);});
    // helper function to check is a given vertex has already been discovered
    const auto is_discovered = [&discovered](const logic_network::vertex _v){return discovered[_v];};

    // joint depth first search
    const std::function<void(const logic_network::vertex)>
    jdfs = [&](const logic_network::vertex _v)
    {
        auto iav = network->inv_adjacent_vertices(_v, io_ports);
        // if all predecessors are yet discovered
        if (std::all_of(iav.begin(), iav.end(), is_discovered))
        {
            discovered[_v] = true;
            ordering.push_back(_v);

            for (auto&& av : network->adjacent_vertices(_v, io_ports) | iter::filterfalse(is_discovered))
                jdfs(av);
        }
    };

    // call joint dfs for each vertex without predecessors
    for (auto&& root : network->vertices(io_ports) | iter::filter([this](const logic_network::vertex _v)
                                                                  {return network->in_degree(_v, io_ports) == 0u;}))
        jdfs(root);

    return ordering;
}

migorthogonal_pr::red_blue_coloring migorthogonal_pr::find_rb_coloring(const jdfs_ordering& jdfs) const noexcept
{
    red_blue_coloring rb_coloring{};

    const auto contrary = [](const rb_color _c){return _c == rb_color::RED ? rb_color::BLUE : rb_color::RED;};

    // range of logic edges
    auto edges = network->edges(io_ports);
    // color all edges white initially
    std::for_each(edges.begin(), edges.end(),
                  [&rb_coloring](const logic_network::edge& _e){rb_coloring.emplace(_e, rb_color::WHITE);});

    const std::function<void(const logic_network::edge&, const rb_color)>
            apply = [&](const logic_network::edge& _e, const rb_color _c)
    {
        if (rb_coloring[_e] != rb_color::WHITE)
            return;

        rb_coloring[_e] = _c;

        for (auto&& oe : network->out_edges(network->source(_e), io_ports))
        {
            if (oe != _e)
                apply(oe, contrary(_c));
        }

        for (auto&& ie : network->in_edges(network->target(_e), io_ports))
        {
            if (ie != _e)
                apply(ie, _c);
        }
    };

    for (auto&& v : jdfs | iter::reversed)
    {
        auto ie = network->in_edges(v, io_ports);
        // if any ingoing edge is BLUE, color them all in BLUE, and RED otherwise
        auto color = std::any_of(ie.begin(), ie.end(),
                                 [&rb_coloring](const logic_network::edge& _e)
                                               {return rb_coloring[_e] == rb_color::BLUE;}) ?
                     rb_color::BLUE :
                     rb_color::RED;

        for (auto&& e : ie)
            apply(e, color);
    }

    return rb_coloring;
}

//aplica o posicionamento e roteamento
void migorthogonal_pr::migorthogonal_embedding(red_blue_coloring& rb_coloring, const jdfs_ordering& jdfs)
{
    // create layout with x = v, y = v, where v is the number of vertices in the network
    // therefore, the layout needs to be shrunk to fit in the end
    layout = std::make_shared<fcn_gate_layout>(fcn_dimension_xy{network->vertex_count(io_ports), network->vertex_count(io_ports)},
                                               phases == 3 ? std::move(twoddwave_3_clocking) :
                                                             std::move(twoddwave_4_clocking), network);
    // cache map storing information about where vertices were placed on the layout
    std::unordered_map<logic_network::vertex, fcn_gate_layout::tile> pos;


    //JULIO
    /**
     * Function to connect two tiles in the layout via a vertical wire connection in southern direction, where t1 and
     * t2 are the two tiles that should be connected by logic edge e.
     */
    //@param bent defined by JULIO (double wire)
    auto fixed_wrong_via = [&](int x, int y, int z)
    {
        fcn_gate_layout::tile t1{x,y,z+1};
        fcn_gate_layout::tile t2{x,y,(z)};
        auto dirinputT1     = layout->get_tile_inp_dirs(t1);
        auto diroutputT1    = layout->get_tile_out_dirs(t1);
        auto edges_t1       = layout->get_logic_edges(t1); //logic edges_set
        logic_network::edge edge_t1;
        for(auto e:edges_t1){
            edge_t1 = e;
            layout->dissociate_logic_edge(t1,e);
        }
        layout->clear_tile(t1);
        auto dirT2          = layout->get_tile_inp_dirs(t2);
        auto diroutputT2    = layout->get_tile_out_dirs(t2);
        auto edges_t2       = layout->get_logic_edges(t2); //logic edges_set
        logic_network::edge edge_t2;
        for(auto ee:edges_t2){
            edge_t2 = ee;
            layout->dissociate_logic_edge(t2,ee);
        }
        layout->clear_tile(t2);
        //layer GROUND
        fcn_gate_layout::tile t1prev{(t1.elems[0]-1),t1.elems[1],t1.elems[2]};
        layout->assign_logic_edge(t2, edge_t1);
        layout->assign_wire_inp_dir(t2, edge_t1,layout::opposite(layout::DIR_E));
        layout->assign_tile_inp_dir(t2, layout::opposite(layout::DIR_E));
        layout->assign_wire_out_dir(t1prev, edge_t1,layout::DIR_E);
         layout->assign_tile_out_dir(t1prev,layout::DIR_E);
         fcn_gate_layout::tile t1next{(t1.elems[0]+1),t1.elems[1],t1.elems[2]};
         layout->assign_wire_inp_dir(t1next, edge_t1,layout::opposite(layout::DIR_E));
         layout->assign_tile_inp_dir(t1next, layout::opposite(layout::DIR_E));
         layout->assign_wire_out_dir(t2, edge_t1,layout::DIR_E);
         layout->assign_tile_out_dir(t2,layout::DIR_E);
         //layer n=1
         fcn_gate_layout::tile t2prev{t2.elems[0],(t2.elems[1]-1),t2.elems[2]};
         layout->assign_logic_edge(t1, edge_t2);
         layout->assign_wire_inp_dir(t1, edge_t2,layout::DIR_NW);
         layout->assign_tile_inp_dir(t1, layout::DIR_NW);
         layout->assign_wire_out_dir(t2prev, edge_t2,layout::DIR_S);
         layout->assign_tile_out_dir(t2prev,layout::DIR_S);
         fcn_gate_layout::tile t2next{t2.elems[0],(t2.elems[1]+1),t2.elems[2]};
         layout->assign_wire_inp_dir(t2next, edge_t2,layout::opposite(layout::DIR_S));
         layout->assign_tile_inp_dir(t2next, layout::opposite(layout::DIR_S));
         layout->assign_wire_out_dir(t1, edge_t2,layout::DIR_S);
         layout->assign_tile_out_dir(t1,layout::DIR_S);
    };


    /**
     * Function to set the direction of tiles where the names of current_tile and previous_tile refer to information
     * flow direction.
     */
    auto assign_wire_dir = [&](const fcn_gate_layout::tile& current_tile, const fcn_gate_layout::tile& previous_tile,
                                       const layout::directions dir, const logic_network::edge& e)
    {
        auto t1 = (layout->has_logic_edge(current_tile, e) ||
        layout->is_gate_tile(current_tile)) ? current_tile : layout->above(current_tile);
        layout->assign_wire_inp_dir(t1, e, layout::opposite(dir));
        layout->assign_tile_inp_dir(t1, layout::opposite(dir));

        auto t2 = (layout->has_logic_edge(previous_tile, e) ||
        layout->is_gate_tile(previous_tile)) ? previous_tile : layout->above(previous_tile);

        //JULIO
        layout->assign_wire_out_dir(t2, e, dir);
        layout->assign_tile_out_dir(t2, dir);


        fcn_gate_layout::tile prev_current_tile{current_tile.elems[0],(current_tile.elems[1]-1),current_tile.elems[2]};
        //JULIO
        if(
        (!(layout->has_logic_edge(current_tile, e))||!(layout->is_gate_tile(current_tile)))//é edge (sequencia de wire)
        &&(layout->get_op(current_tile) == operation::W) //é um fio
        &&(dir == layout::DIR_E) //vai assinar para E
        &&(layout->get_tile_inp_dirs(current_tile)==layout::DIR_NW)
        &&(t1.elems[2]>0u)
        ){
           fcn_gate_layout::tile below_tile = layout->below(current_tile);
           fixed_wrong_via(current_tile.elems[0],current_tile.elems[1],current_tile.elems[2]);
        }
    };
    //JULIO---------------------------DOUBLE WIRE------------------------------------
    auto assign_double_wire_dir = [this](const fcn_gate_layout::tile& current_tile, const fcn_gate_layout::tile& previous_tile,
                                        const layout::directions dirT1,const layout::directions dirT2, const logic_network::edge& e)
    {
        auto t1 = (layout->has_logic_edge(current_tile, e) ||
                   layout->is_gate_tile(current_tile)) ? current_tile : layout->above(current_tile);
        auto t2 = (layout->has_logic_edge(previous_tile, e) ||
                   layout->is_gate_tile(previous_tile)) ? previous_tile : layout->above(previous_tile);
        layout->assign_wire_inp_dir(t1, e, dirT1);
        layout->assign_tile_inp_dir(t1, dirT1);
        layout->assign_wire_out_dir(t2, e, dirT2);
        layout->assign_tile_out_dir(t2, dirT2);
    };

    /**
     * Function to connect two tiles in the layout via a horizontal wire connection in eastern direction, where t1 and
     * t2 are the two tiles that should be connected by logic edge e.
     */
    //@param bent defined by JULIO (double wire)
    auto wire_east = [&](const fcn_gate_layout::tile& t1, const fcn_gate_layout::tile& t2, logic_network::edge& e ,
            const bool bent)
    {

       //JULIO
       for (auto&& i : iter::range(t1[X] + 1u, t2[X]))
       {
            auto current_tile  = fcn_gate_layout::tile{i, t1[Y], GROUND};
            auto previous_tile = fcn_gate_layout::tile{i - 1, t1[Y], GROUND};
            auto above_tile    = fcn_gate_layout::tile{i, t1[Y-1], GROUND};

           //JULIO
           const bool currentWire  = layout->is_wire_tile(current_tile);
           layout->is_wire_tile(current_tile) ? layout->assign_logic_edge(layout->above(current_tile), e)
                                              : layout->assign_logic_edge(current_tile, e);

            //JULIO
            if(network->get_op(e.m_source) == operation::F2O2 )
            {
                //JULIO
               if((i==t2[X]-1)&&(bent==true)&&(currentWire!=true)&&(layout->get_tile_inp_dirs(previous_tile) != layout::DIR_NESW)){

                   assign_double_wire_dir(current_tile, previous_tile,layout::DIR_NESW, layout::DIR_E, e);
               }else{
                   assign_double_wire_dir(current_tile, previous_tile,layout::DIR_NW, layout::DIR_E, e);
               }

            }
            else{
                assign_wire_dir(current_tile, previous_tile, layout::DIR_E, e);
            }
       }
    };
    /**
     * Function to connect two tiles in the layout via a vertical wire connection in southern direction, where t1 and
     * t2 are the two tiles that should be connected by logic edge e.
     */
    //@param bent defined by JULIO (double wire)
    auto wire_south = [&](const fcn_gate_layout::tile& t1, const fcn_gate_layout::tile& t2, logic_network::edge& e,
            bool bent)
    {
        //JULIO
        for (auto&& i : iter::range(t1[Y] + 1u, t2[Y]))
        {
           //JULIO
            auto current_tile  = fcn_gate_layout::tile{t1[X], i, GROUND};
            auto previous_tile = fcn_gate_layout::tile{t1[X], i - 1, GROUND};
            auto side_tile     = fcn_gate_layout::tile{t1[X-1],i , GROUND};

            //JULIO
           const bool currentWire  = layout->is_wire_tile(current_tile);
            // if there was an edge assigned already, create a crossing
            layout->is_wire_tile(current_tile) ? layout->assign_logic_edge(layout->above(current_tile), e)
                                               : layout->assign_logic_edge(current_tile, e);
            if(network->get_op(e.m_source) == operation::F2O2 )
            {
               if((i==t2[Y]-1)&&(bent==true)&&(currentWire!=true)&&(layout->get_tile_inp_dirs(previous_tile) != layout::DIR_NESW)){
                   //JULIO
                   assign_double_wire_dir(current_tile, previous_tile,layout::DIR_NESW, layout::DIR_S, e);
               }
               else{
                   //JULIO
                   assign_double_wire_dir(current_tile, previous_tile,layout::DIR_NW, layout::DIR_S, e);
               }
            }
            else{
                assign_wire_dir(current_tile, previous_tile, layout::DIR_S, e);
            }
        }
    };

    // helper variables due to a bug in the BGL. See https://svn.boost.org/trac10/ticket/11735 for details.
    auto x_helper = 0u, y_helper = 0u;
    //JULIO
    for (auto& v : jdfs)
    {
        // if operation has no predecessors, add 1 row and 1 column to the grid
        if (network->in_degree(v, io_ports) == 0u)
        {
            fcn_gate_layout::tile t{x_helper, y_helper, GROUND};
            layout->assign_logic_vertex(t, v, io_ports ? network->is_pi(v) : network->pre_pi(v),
                                              io_ports ? network->is_po(v) : network->post_po(v));
            pos.emplace(v, t);

            ++x_helper; ++y_helper;
        }
    }
    //JULIO
    for (auto& v : jdfs)
    {
        if (network->in_degree(v, io_ports) == 0u)
        {
        }
        // if operation has one predecessor, add either 1 row or 1 column
        else if (network->in_degree(v, io_ports) == 1u)
        {
            //JULIO
            // incoming edge
            auto in_e = *network->in_edges(v, io_ports).begin();
            // predecessor tile
            const auto pre_t = pos[network->source(in_e)];

            // edge is RED (horizontal)
            if (rb_coloring[in_e] == rb_color::RED)
            {
                //JULIO
                // y-position is determined by predecessor
                const auto y_pos = pre_t[Y];
                //JULIO
                fcn_gate_layout::tile t{x_helper, y_pos, GROUND};
                layout->assign_logic_vertex(t, v, io_ports ? network->is_pi(v) : network->pre_pi(v),
                                                  io_ports ? network->is_po(v) : network->post_po(v));
                pos.emplace(v, t);

                wire_east(pre_t, t, in_e,false);

                // assign operation directions
                assign_wire_dir({pre_t[X] + 1, pre_t[Y], GROUND}, pre_t, layout::DIR_E, in_e);
                assign_wire_dir(t, {t[X] - 1, t[Y], GROUND}, layout::DIR_E, in_e);

                ++x_helper;
            }
            // edge is BLUE (vertical)
            else
            {
                //JULIO
                // x position is determined by predecessor
                const auto x_pos = pre_t[X];
                //JULIO

                fcn_gate_layout::tile t{x_pos, y_helper, GROUND};
                layout->assign_logic_vertex(t, v, io_ports ? network->is_pi(v) : network->pre_pi(v),
                                                  io_ports ? network->is_po(v) : network->post_po(v));
                pos.emplace(v, t);

                wire_south(pre_t, t, in_e,false);

                // assign operation directions
                assign_wire_dir({pre_t[X], pre_t[Y] + 1, GROUND}, pre_t, layout::DIR_S, in_e);
                assign_wire_dir(t, {t[X], t[Y] - 1, GROUND}, layout::DIR_S, in_e);

                ++y_helper;
            }
        }
        // operation has two predecessors
        else
        {
            //JULIO
            auto ep = network->in_edges(v, io_ports).begin();
            // incoming edge 1
            const auto e1 = *ep;
            ++ep;
            // incoming edge 2
            const auto e2 = *ep;

            // there cannot be more than two incoming wires
            const std::vector<std::pair<logic_network::edge, logic_network::vertex>>
                    evp{std::make_pair(e1, network->source(e1)),
                        std::make_pair(e2, network->source(e2))};

            fcn_gate_layout::tile t;

            // determine placement based on colors first

            // both edges are red
            if (rb_coloring[e1] == rb_coloring[e2] && rb_coloring[e1] == rb_color::RED)
            {
                //JULIO
                // determine y-position
                auto max_y = *std::max_element(evp.begin(), evp.end(),
                                               [&](const std::pair<logic_network::edge, logic_network::vertex>& ev1,
                                                   const std::pair<logic_network::edge, logic_network::vertex>& ev2)
                                               {return pos[ev1.second][Y] <= pos[ev2.second][Y];});

                auto const y_pos = pos[max_y.second][Y];
                //JULIO
                t = fcn_gate_layout::tile{x_helper, y_pos, GROUND};
                ++x_helper;
            }
            // both edges are blue
            else if (rb_coloring[e1] == rb_coloring[e2] && rb_coloring[e1] == rb_color::BLUE)
            {
                //JULIO
                // determine x-position
                auto max_x = *std::max_element(evp.begin(), evp.end(),
                                               [&pos](const std::pair<logic_network::edge, logic_network::vertex>& ev1,
                                                      const std::pair<logic_network::edge, logic_network::vertex>& ev2)
                                               {return pos[ev1.second][X] <= pos[ev2.second][X];});

                auto x_pos = pos[max_x.second][X];
                //JULIO
                t = fcn_gate_layout::tile{x_pos, y_helper, GROUND};
                ++y_helper;
            }
            // both edges are different (handles coloring conflict case)
            else
            {
                //JULIO
                t = fcn_gate_layout::tile{x_helper, y_helper, GROUND};
                ++x_helper; ++y_helper;
            }

            // place operation
            layout->assign_logic_vertex(t, v, io_ports ? network->is_pi(v) : network->pre_pi(v),
                                              io_ports ? network->is_po(v) : network->post_po(v));
            pos.emplace(v, t);
            // do routing dependent on colors
            for (auto& ev : evp)
            {
                // previous edge
                auto pre_e = ev.first;
                // previous vertex
                const auto pre_v = ev.second;
                // previous tile
                auto pre_t = pos[pre_v];
                //JULIO

                // if edge is red
                if (rb_coloring[pre_e] == rb_color::RED)
                {
                    // check if a bent is necessary
                    const bool benting_wire = pre_t[Y] != t[Y];
                    //JULIO
                    wire_east(pre_t, (benting_wire ? fcn_gate_layout::tile{t[X] + 1, pre_t[Y], GROUND} : t),
                            pre_e,benting_wire);
                    assign_wire_dir({pre_t[X] + 1, pre_t[Y], GROUND}, pre_t, layout::DIR_E, pre_e);

                    // vertical connection will only be needed if wire has a bend
                    if (benting_wire)
                    {
                        // assign vertical connection
                        wire_south({t[X], pre_t[Y], GROUND}, t, pre_e,false);
                        // assign direction
                        assign_wire_dir(t, {t[X], t[Y] - 1, GROUND}, layout::DIR_S, pre_e);
                    }
                    else
                    {
                        // assign direction
                        assign_wire_dir(t, {t[X] - 1, t[Y], GROUND}, layout::DIR_E, pre_e);
                    }
                }
                else  // edge is blue
                {
                    // check if a bend is necessary
                    const bool benting_wire = pre_t[X] != t[X];
                    //JULIO
                    wire_south(pre_t, (benting_wire ? fcn_gate_layout::tile{pre_t[X], t[Y] + 1, GROUND} : t),
                            pre_e,benting_wire);

                    assign_wire_dir({pre_t[X], pre_t[Y] + 1, GROUND}, pre_t, layout::DIR_S, pre_e);

                    // horizontal connection will only be needed if wire has a bend
                    if (benting_wire)
                    {
                        // assign horizontal connection
                        wire_east({pre_t[X], t[Y], GROUND}, t, pre_e,false);
                        // assign direction
                        assign_wire_dir(t, {t[X] - 1, t[Y], GROUND}, layout::DIR_E, pre_e);
                    }
                    else
                    {
                        // assign direction
                        assign_wire_dir(t, {t[X], t[Y] - 1, GROUND}, layout::DIR_S, pre_e);
                    }
                }
            }
        }
    }
    layout->shrink_to_fit();
}

