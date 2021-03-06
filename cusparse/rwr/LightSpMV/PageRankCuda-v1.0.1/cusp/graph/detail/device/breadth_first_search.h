/*
 *  Copyright 2008-2014 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
#pragma once

#include <cusp/exception.h>

#include <cusp/graph/detail/device/b40c.h>

namespace cusp
{
namespace graph
{
namespace detail
{
namespace device
{

template<bool MARK_PREDECESSORS, typename MatrixType, typename ArrayType>
void breadth_first_search(const MatrixType& G, const typename MatrixType::index_type src,
                          ArrayType& labels)
{
    typedef typename MatrixType::index_type VertexId;

    typedef b40c::graph::bfs::CsrProblem<VertexId, VertexId, MARK_PREDECESSORS> CsrProblem;
    typedef typename CsrProblem::GraphSlice  GraphSlice;

    int max_grid_size = 0;
    double max_queue_sizing = 1.15;

    VertexId nodes = G.num_rows;
    VertexId edges = G.num_entries;

    CsrProblem csr_problem;
    csr_problem.nodes = nodes;
    csr_problem.edges = edges;
    csr_problem.num_gpus = 1;

    if( labels.size() != G.num_rows )
    {
        throw cusp::runtime_exception("BFS traversal labels is not large enough for result.");
    }

    // Create a single GPU slice for the currently-set gpu
    int gpu;
    if (b40c::util::B40CPerror(cudaGetDevice(&gpu), "CsrProblem cudaGetDevice failed", __FILE__, __LINE__))
    {
        throw cusp::runtime_exception("B40C cudaGetDevice failed.");
    }
    csr_problem.graph_slices.push_back(new GraphSlice(gpu, 0));
    csr_problem.graph_slices[0]->nodes = nodes;
    csr_problem.graph_slices[0]->edges = edges;
    csr_problem.graph_slices[0]->d_row_offsets = (VertexId *) thrust::raw_pointer_cast(&G.row_offsets[0]);
    csr_problem.graph_slices[0]->d_column_indices = (VertexId *) thrust::raw_pointer_cast(&G.column_indices[0]);
    csr_problem.graph_slices[0]->d_labels = (VertexId *) thrust::raw_pointer_cast(&labels[0]);

    b40c::graph::bfs::EnactorHybrid<false/*INSTRUMENT*/>  hybrid(false);
    csr_problem.Reset(hybrid.GetFrontierType(), max_queue_sizing);

    hybrid.EnactSearch<CsrProblem>(csr_problem, src, max_grid_size);

    // Unset pointers to prevent csr_problem deallocations
    csr_problem.graph_slices[0]->d_row_offsets = (VertexId *) NULL;
    csr_problem.graph_slices[0]->d_column_indices = (VertexId *) NULL;
    csr_problem.graph_slices[0]->d_labels = (VertexId *) NULL;
}

} // end namespace device
} // end namespace detail
} // end namespace graph
} // end namespace cusp
