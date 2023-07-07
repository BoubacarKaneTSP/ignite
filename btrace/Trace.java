/*
 * Copyright (c) 2008, 2015, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the Classpath exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */


import org.openjdk.btrace.core.annotations.BTrace;
import org.openjdk.btrace.core.annotations.OnMethod;
import org.openjdk.btrace.core.annotations.OnTimer;
import org.openjdk.btrace.core.annotations.ProbeClassName;
import org.openjdk.btrace.core.annotations.ProbeMethodName;
import org.openjdk.btrace.core.annotations.Self;
import org.openjdk.btrace.core.annotations.Export;
import org.openjdk.btrace.core.annotations.Property;
import org.openjdk.btrace.core.annotations.Duration;
import org.openjdk.btrace.core.annotations.Location;
import org.openjdk.btrace.core.annotations.Kind;

import org.openjdk.btrace.core.BTraceUtils.Aggregations;
import org.openjdk.btrace.core.aggregation.Aggregation;
import org.openjdk.btrace.core.aggregation.AggregationResult;
import org.openjdk.btrace.core.aggregation.AggregationFunction;

import static org.openjdk.btrace.core.BTraceUtils.*;

/**
 * This script traces method entry into every method of
 * every class in javax.swing package! Think before using
 * this script -- this will slow down your app significantly!!
 */
@BTrace
public class TestMethods {

    // This field will be exported as a JStat counter.
    @Export
    private static long dataAccessed;

    private static long timeMethodCalls;

    private static Aggregation totalTimeMethodCalls = Aggregations
            .newAggregation(AggregationFunction.AVERAGE);

    // This field will be exported to the MBean server.
    @Property
    private static long dataCreated;

    @Property
    private static long cacheChecked;

    private static Aggregation methodDuration = Aggregations
            .newAggregation(AggregationFunction.AVERAGE);

    /**
     * We want to measure how long does the
     * sizex(-) method execution take.
     */
    @OnMethod(clazz="/org\\.apache\\.ignite\\.util\\.deque\\.FastSizeDeque",
            method="/sizex/",
            location = @Location(Kind.RETURN))
    public static void addMethodDuration(@Duration long duration) {
        Aggregations.addToAggregation(methodDuration,
                duration/1000000);

//        dataAccessed++;
    }

    /**
     * Invoked every 10 seconds - not a real probe.
     */
    @OnTimer(value = 10000)
    public static void printAvgMethodDuration() {
        AggregationResult result = Aggregations.getAggregation(methodDuration);
        Aggregations.printAggregation(
                "Average method duration (ms)", result);
    }
}